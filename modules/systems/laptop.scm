(define-module (systems laptop)
  #:use-module (gnu)
  #:use-module (gnu system file-systems)
  #:use-module (systems base))

(operating-system 
  (inherit base)

  (kernel-arguments
    (cons* "modprobe.blacklist=elan_i2c"
	   %default-kernel-arguments))

  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (targets (list "/boot/efi"))
      (keyboard-layout (keyboard-layout "gb"))))

  (swap-devices
    (list (swap-space
            (target (uuid "087ac440-d22e-4fd5-acd6-10031225f514")))))

  (mapped-devices
    (list (mapped-device
            (source (uuid "4ebcc11d-e64f-4807-a9f6-867de329c49f"))
            (target "guix_root_crypt")
            (type luks-device-mapping))))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device "/dev/mapper/guix_root_crypt")
             (type "ext4")
             (dependencies mapped-devices))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "B56E-94F1" 'fat32))
             (type "vfat"))
           %base-file-systems)))
