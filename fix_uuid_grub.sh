# trick from  https://github.com/imperador/chromefy/blob/master/croissant.sh

# we can set PARTUUID using sgdisk like this, sudo apt install gdisk
# sgdisk -u partno:partuuid  /dev/sda
# PARTUUID=$(sudo cgpt show -i 3 -u flex.bin)
# sgdisk -u 3:$PARTUUID  /dev/sda
# PARTUUID=$(sudo cgpt show -i 5 -u flex.bin)
# sgdisk -u 5:$PARTUUID  /dev/sda
# if you do so no need to change grub


mount /dev/sda12 /mnt

 
# get first PARTUUID of ROOT-A from grub.cfg 
OLD_UUID=`cat /mnt/efi/boot/grub.cfg | grep -m 1 "PARTUUID=" | awk -v FS="(PARTUUID=)" '{print $2}' | awk '{print $1}'`  
# get real PARTUUID of ROOT-A which is third partition
PARTUUID=$(sudo cgpt show -i 3 -u /dev/sda)
# PARTUUID=$(sudo sfdisk --part-uuid /dev/sda 3)
sed -i "s/$OLD_UUID/$PARTUUID/" /mnt/efi/boot/grub.cfg
echo "EFI: Partition UUID $OLD_UUID changed to $PARTUUID" 

# get 4th PARTUUID which is ROOT-B from grub plz verify this
OLD_UUID=$(grep "PARTUUID=" /mnt/efi/boot/grub.cfg | sed -n '4p' | awk -F'PARTUUID=' '{print $2}' | awk '{print $1}')
PARTUUID=$(sudo cgpt show -i 5 -u /dev/sda)
# may not work  manually out OLD_UUID below if error 
sed -i "s/$OLD_UUID/$PARTUUID/" /mnt/efi/boot/grub.cfg
