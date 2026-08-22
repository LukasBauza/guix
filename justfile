hostname := `hostname`
home := env("HOME")

update:
  guix pull
  sudo guix system reconfigure -L {{home}} {{home}}/systems/{{hostname}}.scm
  guix home reconfigure -L {{home}} {{home}}/home/home.scm
  flatpak update
