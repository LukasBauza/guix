(define-module (hardware pc-hardware)
  #:use-module (gnu)
  #:use-module (gnu system file-systems)
  ; #:use-module (gnu system bootloader)
  ; #:use-module (gnu system uuid)
  #:export (%my-bootloader
            %my-swap-devices
            %my-mapped-devices
            %my-file-systems))

(define %my-bootloader
  (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets (list "/boot/efi"))
    (keyboard-layout (keyboard-layout "gb"))))

(define %my-swap-devices
  (list (swap-space
          (target (uuid "649c5e49-2ef6-4343-a87c-e6bdfecc36da")))))

(define %my-mapped-devices
  (list (mapped-device
          (source (uuid "e3d1c395-fcf2-4414-a891-fed68766ad7a"))
          (target "guix-system-crypt")
          (type luks-device-mapping))))

(define %my-file-systems
  (cons* (file-system
           (mount-point "/")
           (device "/dev/mapper/guix-system-crypt")
           (type "ext4")
           (dependencies %my-mapped-devices))
         (file-system
           (mount-point "/boot/efi")
           (device (uuid "45BA-ABC4" 'fat32))
           (type "vfat"))
         %base-file-systems))
