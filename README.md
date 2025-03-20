# chrome-flex

# Dual/multi boot manual install 

dont do this on windows as windows boot loader use hardcoded address in bcd like part number, adding part before windows part mess it and need to fix bcd usb recovery  

https://dl.google.com/chromeos-flex/images/latest.bin.zip

make about 100-120gb free space at begining of disk

rename existing partition to part number>=20 as flex uses from 1-12, part numberare hardcoded so that vboot(verified) can easily find : 
```
sudo sfdisk -d /dev/sda > pbakup

rename all part number to sda/nvme/20+

sudo sfdisk /dev/sda <pbakup --force

```
 cat /sys/block/sda/queue/logical_block_size 
512  

 making part works for bs=512 

do be curious and  run cgpt create -p 0 /dev/sda, it will wipe partition table 
```

sudo bash make_partitions.sh
sudo bash write_image.sh flex.bin /dev/sda
sudo bash fix_uuid_grub.sh
```

after first login you need powerwash to use rw_partioin fully else only 1gb is writeable 



  # refrences

 https://github.com/sebanc/brunch/tree/r133 

https://github.com/sebanc/brunch/blob/r133/scripts/chromeos-install.sh

https://chromium.googlesource.com/chromiumos/platform/crosutils/+/HEAD/build_library/README.disk_layout

https://www.chromium.org/chromium-os/developer-library/reference/device/disk-format/

https://chromium.googlesource.com/chromiumos/platform2/+/main/installer/chromeos-install.sh



 
 
