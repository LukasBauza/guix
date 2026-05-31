;; This is a sample Guix Home configuration which can help setup your
;; home directory in the same declarative manner as Guix System.
;; For more information, see the Home Configuration section of the manual.
(use-modules (gnu)
	     (gnu home)
	     (gnu home services)
	     (gnu home services shells)
	     (gnu home services sound)
	     (gnu services)
	     (gnu system shadow))

(define home-config
  (home-environment
    (packages (specifications->packages
		(list "ark"
		      "bat"
		      "node"
		      "chezmoi"
		      "emacs"
		      "git"
		      "kate"
		      "kdeconnect"
		      "konversation"
		      "neovim"
		      "partitionmanager"
		      "zoxide")))
    (services
      (append
        (list
          ;;(service home-bash-service-type)

          (service home-files-service-type
           `((".guile" ,%default-dotguile)
             (".Xdefaults" ,%default-xdefaults)))

          (service home-xdg-configuration-files-service-type
           `(("gdb/gdbinit" ,%default-gdbinit)
             ("nano/nanorc" ,%default-nanorc))))

        %base-home-services))))

home-config
