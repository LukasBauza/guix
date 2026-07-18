(use-modules
  (gnu)
  (gnu packages freedesktop)
  (gnu packages gnome)
  (gnu packages networking)
  (gnu packages wm)
  (nongnu packages linux)
  (nongnu system linux-initrd)

  (hardware pc))
(use-service-modules cups desktop networking ssh xorg)

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "gb"))
  (host-name "guix-system")

  (users (cons* (user-account
                  (name "lukas")
                  (comment "Lukas")
                  (group "users")
                  (home-directory "/home/lukas")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  (packages (append (list
                     (specification->package "font-google-noto")
                     (specification->package "font-google-noto-emoji")
                     (specification->package "font-sarasa-gothic")
		     (specification->package "flatpak"))
                    %base-packages))

  (services
   (append (list (service plasma-desktop-service-type)
		 (service bluetooth-service-type)

       (service openssh-service-type)
       (service cups-service-type)
       (set-xorg-configuration
        (xorg-configuration (keyboard-layout keyboard-layout))))
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
