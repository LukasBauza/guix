hostname := `hostname`
home := env("HOME")
guix_src_dir := home / ".config/guix/src"

up: pull sys home flat

pull:
  guix pull

sys:
  sudo guix system reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/systems/{{hostname}}.scm

home:
  guix home reconfigure -L {{guix_src_dir}} {{guix_src_dir}}/home/home.scm

flat:
  flatpak update
