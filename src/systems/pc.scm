(define-module (systems pc)
  #:use-module (gnu)
  #:use-module (gnu system file-systems)
  #:use-module (systems base))

(operating-system 
  (inherit base)

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout (keyboard-layout "gb"))))

  (swap-devices
    (list (swap-space
            (target (uuid "649c5e49-2ef6-4343-a87c-e6bdfecc36da")))))

  (mapped-devices
    (list (mapped-device
            (source (uuid "e3d1c395-fcf2-4414-a891-fed68766ad7a"))
            (target "guix-system-crypt")
            (type luks-device-mapping))))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/guix-system-crypt")
             (type "ext4")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "45BA-ABC4" 'fat32))
             (type "vfat"))
           %base-file-systems)))
