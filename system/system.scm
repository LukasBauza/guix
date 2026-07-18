;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules
  (gnu)
  (gnu packages freedesktop)
  (gnu packages gnome)
  (gnu packages networking)
  (gnu packages wm)
  (nongnu packages linux)
  (nongnu system linux-initrd)

  (hardware pc-hardware))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "gb"))
  (host-name "guix-system")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "lukas")
                  (comment "Lukas")
                  (group "users")
                  (home-directory "/home/lukas")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list
		      ;; Niri stuff
		      niri
		      xdg-desktop-portal
		      xdg-desktop-portal-gtk
          network-manager-applet
          blueman
                     ;; Fonts to cover all languages.
                     (specification->package "font-google-noto")
                     (specification->package "font-google-noto-emoji")
                     (specification->package "font-sarasa-gothic")
		     (specification->package "flatpak"))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service plasma-desktop-service-type)
		 (service bluetooth-service-type)

       ;; To configure OpenSSH, pass an 'openssh-configuration'
       ;; record as a second argument to 'service' below.
       (service openssh-service-type)
       (service cups-service-type)
       (set-xorg-configuration
        (xorg-configuration (keyboard-layout keyboard-layout))))
   ;; This is the default list of services we
   ;; are appending to.
   (modify-services %desktop-services
		   (guix-service-type config => (guix-configuration
						  (inherit config)
						  (substitute-urls
						    (append (list "https://substitutes.nonguix.org") %default-substitute-urls))
						  (authorized-keys
						    (append (list (local-file "signing-key.pub"))
							    %default-authorized-guix-keys)))))))

  (bootloader %my-bootloader)
  (swap-devices %my-swap-devices)
  (mapped-devices %my-mapped-devices)
  (file-systems %my-file-systems))
