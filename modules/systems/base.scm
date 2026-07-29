(define-module (systems base)
               #:use-module (gnu)
               #:use-module (gnu packages freedesktop)
               #:use-module (gnu packages gnome)
               #:use-module (gnu packages networking)
               #:use-module (gnu services cups)
               #:use-module (gnu services desktop)
               #:use-module (gnu services ssh)
               #:use-module (gnu services xorg)
               #:use-module (nongnu packages linux)
               #:use-module (nongnu system linux-initrd)
               #:export (base))

(define base
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

    (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))

    (swap-devices (list (swap-space
                        (target (uuid
                                 "087ac440-d22e-4fd5-acd6-10031225f514")))))

    (mapped-devices (list (mapped-device
                          (source (uuid
                                   "4ebcc11d-e64f-4807-a9f6-867de329c49f"))
                          (target "guix_root_crypt")
                          (type luks-device-mapping))))

  (file-systems (cons* (file-system
                         (mount-point "/")
                         (device "/dev/mapper/guix_root_crypt")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "B56E-94F1"
                                       'fat32))
                         (type "vfat")) %base-file-systems))))
