set shell := ["nu", "-c"]

hostname := `hostname`
home := env("HOME")
guix_src_dir := home / ".config/guix/src"

update:
  #!/usr/bin/env nu
  sudo -v
  let keep_alive = job spawn {
    loop {
      sudo -n true
      sleep 60sec
    }
  }
  just pull
  just system
  job kill $keep_alive
  just home
  just flat

pull:
  guix pull

system:
  sudo guix system reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/systems/{{hostname}}.scm

home:
  guix home reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/home/home.scm

flat:
  flatpak update -y
