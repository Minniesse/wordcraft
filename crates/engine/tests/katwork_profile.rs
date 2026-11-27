//! The KatWork build profile: the engine built without `font-download` and `ssip`
//! (`--no-default-features`). Without `font-download` there is no font store, so the language-pack
//! commands that download into it or remove from it are unknown commands. Without `ssip` Read Aloud
//! uses only the speech programs: it never connects to the Speech Dispatcher address in
//! `SPEECHD_ADDRESS` and never starts `speech-dispatcher`. Each group compiles only with its gate off.
#![allow(clippy::unwrap_used, clippy::panic)]

#[cfg(not(feature = "font-download"))]
mod pack_store {
    use serde_json::json;
    use wordcraft_engine::{CmdError, Session, packs};

    #[test]
    fn the_pack_store_commands_are_unknown_and_there_is_no_store() {
        let mut s = Session::new(wordcraft_engine::sample::sample_document());
        for id in ["proof.installPack", "proof.removePack"] {
            assert_eq!(s.run(id, &json!({"locale": "nl"})), Err(CmdError::Unknown(id.into())), "`{id}` should be an unknown command");
            assert!(wordcraft_engine::cmd::registry().get(id).is_none(), "`{id}` is still registered");
        }
        // The CLI's start-up call finds no store, and the list says so; fetching it again is refused.
        assert!(!packs::use_font_store(false));
        let list = s.run("proof.packs", &json!({})).unwrap();
        assert_eq!(list["available"], false, "{list}");
        assert!(s.run("proof.packs", &json!({"refresh": true})).is_err());
    }
}

/// The SSIP client exists only on Linux and the BSDs (`speech/ssip.rs`).
#[cfg(all(unix, not(target_os = "macos"), not(feature = "ssip")))]
mod read_aloud {
    use std::io::ErrorKind;
    use std::net::TcpListener;
    use std::os::unix::fs::PermissionsExt;
    use std::path::{Path, PathBuf};
    use std::process::Command;
    use std::time::{Duration, Instant};

    use serde_json::json;
    use wordcraft_engine::Session;
    use wordcraft_engine::speech::{Backend, State};

    /// Set in the child process this test binary starts: only there does [`child_reads_aloud`] read.
    const CHILD: &str = "WORDCRAFT_KATWORK_READ_ALOUD_CHILD";
    const ERROR: &str = "READ ALOUD ERROR: ";

    /// Reads the sample document aloud with the system's speech programs and prints how it ended.
    /// The environment (PATH, SPEECHD_ADDRESS) is the parent's choice: the workspace forbids
    /// `unsafe`, so the tests can't set it in their own process.
    #[test]
    fn child_reads_aloud() {
        if std::env::var_os(CHILD).is_none() {
            return;
        }
        let mut s = Session::new(wordcraft_engine::sample::sample_document());
        s.read_aloud.backend = Backend::System;
        s.run("review.readAloud", &json!({})).unwrap();
        let until = Instant::now() + Duration::from_secs(30);
        while s.read_aloud.state() != State::Stopped && Instant::now() < until {
            std::thread::sleep(Duration::from_millis(20));
        }
        // On its own line: the test harness prints the test name before it.
        println!("\n{ERROR}{}", s.read_aloud.error().unwrap_or_default());
        s.read_aloud.stop();
    }

    struct Scratch(PathBuf);
    impl Drop for Scratch {
        fn drop(&mut self) {
            let _ = std::fs::remove_dir_all(&self.0);
        }
    }

    /// A folder that is the child's whole PATH: no espeak, and a `speech-dispatcher` that only
    /// leaves a mark that it ran.
    fn path_dir(name: &str) -> Scratch {
        let dir = std::env::temp_dir().join(format!("wordcraft-katwork-{name}-{}", std::process::id()));
        let _ = std::fs::remove_dir_all(&dir);
        std::fs::create_dir_all(&dir).unwrap();
        let fake = dir.join("speech-dispatcher");
        std::fs::write(&fake, "#!/bin/sh\n: > \"$0.ran\"\nexit 1\n").unwrap();
        std::fs::set_permissions(&fake, std::fs::Permissions::from_mode(0o755)).unwrap();
        Scratch(dir)
    }

    fn spawned(dir: &Path) -> bool {
        dir.join("speech-dispatcher.ran").exists()
    }

    /// Runs [`child_reads_aloud`] in a child with only `PATH` and `SPEECHD_ADDRESS` set; the
    /// error Read Aloud ended with.
    fn read_aloud_in_child(path: &Path, address: &str) -> String {
        let out = Command::new(std::env::current_exe().unwrap())
            .args(["--exact", "read_aloud::child_reads_aloud", "--nocapture", "--test-threads=1"])
            .env_clear()
            .env("PATH", path)
            .env("SPEECHD_ADDRESS", address)
            .env(CHILD, "1")
            .output()
            .unwrap();
        let stdout = String::from_utf8_lossy(&out.stdout);
        assert!(out.status.success(), "the child failed: {stdout}{}", String::from_utf8_lossy(&out.stderr));
        stdout.lines().find_map(|l| l.split_once(ERROR).map(|(_, e)| e)).unwrap_or_else(|| panic!("the child didn't read: {stdout}")).to_string()
    }

    /// The speech programs were tried and none was found: Read Aloud ran its speak path.
    fn assert_no_program(error: &str) {
        assert!(error.contains("espeak-ng"), "Read Aloud should say it needs a speech program, got {error:?}");
    }

    #[test]
    fn read_aloud_never_connects_to_speechd_address() {
        let dir = path_dir("tcp");
        let listener = TcpListener::bind("127.0.0.1:0").unwrap();
        listener.set_nonblocking(true).unwrap();
        let port = listener.local_addr().unwrap().port();
        let error = read_aloud_in_child(&dir.0, &format!("inet_socket:127.0.0.1:{port}"));
        match listener.accept() {
            Err(e) if e.kind() == ErrorKind::WouldBlock => {}
            other => panic!("Read Aloud connected to the address in SPEECHD_ADDRESS: {other:?} (it ended with {error:?})"),
        }
        assert_no_program(&error);
        assert!(!spawned(&dir.0), "Read Aloud started speech-dispatcher");
    }

    #[test]
    fn read_aloud_never_starts_speech_dispatcher() {
        let dir = path_dir("spawn");
        // A socket nobody listens on: the client would start the server for it.
        let error = read_aloud_in_child(&dir.0, &format!("unix_socket:{}", dir.0.join("none.sock").display()));
        assert!(!spawned(&dir.0), "Read Aloud started speech-dispatcher (it ended with {error:?})");
        assert_no_program(&error);
    }
}
