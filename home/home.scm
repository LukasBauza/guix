;; This is a sample Guix Home configuration which can help setup your
;; home directory in the same declarative manner as Guix System.
;; For more information, see the Home Configuration section of the manual.
(use-modules (gnu)
	     (gnu home)
	     (gnu home services)
	     (gnu home services niri)
	     (gnu home services shells)
	     (gnu home services sound)
	     (gnu packages terminals)
       (gnu packages wm)
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
          "lem"
		      ;; Nvim stuff
		      "neovim"

		      "nushell"
          ;; TODO Should probably be within system.
		      "partitionmanager"
		      "ripgrep"
		      "wezterm"
          "wl-clipboard"
		      ;; TODO: Needs to setup with the shell.
		      "zoxide")))
    (services
      (append
        (list
          ;;(service home-bash-service-type)
	        (service home-niri-service-type)

          ;; TODO May need to remove the pulseaudio from system.scm, as its not being used?
          (service home-pipewire-service-type)

          (service home-files-service-type
           `((".guile" ,%default-dotguile)
             (".Xdefaults" ,%default-xdefaults)))

          (service home-xdg-configuration-files-service-type
           `(("gdb/gdbinit" ,%default-gdbinit)
             ("nano/nanorc" ,%default-nanorc))))

        %base-home-services))))

home-config
