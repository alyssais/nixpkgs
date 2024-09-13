use std::{fs, os::unix::process::CommandExt, process::Command};

const LD_SO_CONF: &str = r#"
/lib
/lib/x86_64-linux-gnu
/lib64
/usr/lib
/usr/lib/x86_64-linux-gnu
/usr/lib64
/lib/i386-linux-gnu
/lib32
/usr/lib/i386-linux-gnu
/usr/lib32
/run/opengl-driver/lib
/run/opengl-driver-32/lib
"#;

fn main() {
    fs::write("/etc/ld.so.conf", LD_SO_CONF).expect("Failed to generate ld.so.conf!");

    Command::new("ldconfig")
        .env_clear()
        .status()
        .expect("Failed to run ldconfig!");

    Command::new("/init")
        .args(std::env::args_os().skip(1))
        .exec();

    panic!("Failed to exec stage 2 init!");
}
