# chrome-flex

# Dual/multi boot manual install 

dont do this on windows as windows boot loader use hardcoded address in bcd like part number, adding part before windows part mess it and need to fix bcd usb recovery  

you need to install windows after installing flex first as it uses partition number for booting and windows does same but windows is flexible maybe it will change in future 

for linux as long as it use uuid/partuuid it will not care about partiton number

# dependecies
sudo apt install cgpt pv

https://dl.google.com/chromeos-flex/images/latest.bin.zip

make about 100-120gb free space at begining of disk

rename existing partition to part number>=20 as flex uses from 1-12, part numberare hardcoded so that vboot(verified) can easily find : 
```

# important backup partition table so that even if you mess up during partition creation you can easily undo before using dd make sure partition are aligned properly without overlap

sudo sfdisk -d /dev/sda > pbakup

rename all part number to sda/nvme/20+

example:
/dev/sda1 : start=  1658824704, size=     1048576, type=SOME_RANDOM, uuid=SOME_RANDOM
/dev/sda2 : start=  1743759360, size=   209764352, type=SOME_RANDOM, uuid=SOME_RANDOM
/dev/sda3 : start=  1616881664, size=    41943040, type=SOME_RANDOM4, uuid=SOME_RANDOM

rename it as

/dev/sda20 : start=  1658824704, size=     1048576, type=SOME_RANDOM, uuid=SOME_RANDOM
/dev/sda21 : start=  1743759360, size=   209764352, type=SOME_RANDOM, uuid=SOME_RANDOM
/dev/sda22 : start=  1616881664, size=    41943040, type=SOME_RANDOM4, uuid=SOME_RANDOM

cp pbakup backup

# restore modified partition table to change part number

# important : might need reboot save original part backup/ take new one in diffrent non volatile location

sudo sfdisk /dev/sda <pbakup --force

```
 cat /sys/block/sda/queue/logical_block_size 
512  

 making part works for bs=512 
 for diffrent block size 

do be curious and  run cgpt create -p 0 /dev/sda, it will wipe partition table 
```

edit variable b=starting sector and end=ending sector, use cfdisk to see start and end sector of free space
sudo bash make_partitions.sh
sudo bash write_image.sh flex.bin /dev/sda
sudo bash fix_uuid_grub.sh
```

after first login you need powerwash to use rw_partioin ,  else only 1gb is writeable i dont know what command flex installer runs to make it usable 



  # refrences

 https://github.com/sebanc/brunch/tree/r134 

https://github.com/sebanc/brunch/blob/r134/scripts/chromeos-install.sh

https://chromium.googlesource.com/chromiumos/platform/crosutils/+/HEAD/build_library/README.disk_layout

https://www.chromium.org/chromium-os/developer-library/reference/device/disk-format/

https://chromium.googlesource.com/chromiumos/platform2/+/main/installer/chromeos-install.sh



 
 
