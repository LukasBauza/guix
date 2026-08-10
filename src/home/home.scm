(use-modules (gnu)
	     (gnu home)
	     (gnu home services)
       (gnu home services desktop)
	     (gnu home services shells)
       (gnu home services shepherd)
	     (gnu home services sound)
	     (gnu home services syncthing)
	     (gnu packages terminals)
	     (gnu packages xdisorg)
	     (gnu services)
	     (gnu system shadow))

(define home-config
  (home-environment
    (packages (specifications->packages
		(list "ark"
		      "bat"
          "bluez"
          "brightnessctl"
		      "node"
		      "chezmoi"
		      "emacs"
		      "fd"
          "fzf"
		      "git"
          "kcalc"
		      "kdeconnect"
          "kitty"
          "lem"
		      ;; Nvim stuff
		      "neovim"

		      "nushell"
		      "partitionmanager"
          "starship"
		      "ripgrep"
          "wl-clipboard"
		      "zoxide")))
    (services
      (append
        (list
          (service home-shepherd-service-type)
          (service home-syncthing-service-type)
          ;; TODO May need to remove the pulseaudio from system.scm, as its not being used?
          (service home-pipewire-service-type)
          (service home-dbus-service-type)

          (service home-files-service-type
           `((".guile" ,%default-dotguile)
             (".Xdefaults" ,%default-xdefaults)))

          (service home-xdg-configuration-files-service-type
           `(("gdb/gdbinit" ,%default-gdbinit)
             ("nano/nanorc" ,%default-nanorc))))

        %base-home-services))))

home-config
