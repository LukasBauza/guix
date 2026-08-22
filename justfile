set shell := ["nu", "-c"]

hostname := `hostname`
home := env("HOME")
guix_src_dir := home / ".config/guix/src"

up:
  #!/usr/bin/env nu
  sudo -v
  let keep_alive = job spawn {
    loop {
      sudo -n true
      sleep 60sec
    }
  }
  just pull
  just sys
  just home
  just flat
  job kill $keep_alive

pull:
  guix pull

sys:
  sudo guix system reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/systems/{{hostname}}.scm

home:
  guix home reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/home/home.scm

flat:
  flatpak update
