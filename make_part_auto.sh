#!/bin/bash

# cros_size:[16k,512b,1g,512b,512b,64m,64m,16m,64m,4g,4g,flexible)
# cgpt add -b start_block -s size_in_blocks -t part_type -l part_label -i part_id part/address

b=32768
end=124207128
type=(firmware kernel rootfs rootfs reserved reserved kernel data efi rootfs rootfs)
label=("RWFW" "KERN-C" "ROOT-C" "reserved" "reserved" "KERN-A" "KERN-B" "OEM" "EFI-SYSTEM" "ROOT-B" "ROOT-A")
id=(11 6 7 9 10 2 4 8 12 5 3)
size=(16384 8 2097152 8 8 131072 131072 32768 131072 8388608 8388608)

add_partition() {
    local partition_type=$1
    local label=$2
    local partition_id=$3
    local size=$4
    #sudo cgpt add -b $b -s $size -t $partition_type -l "$label" -i $partition_id /dev/sda
    echo "sudo cgpt add -b $b -s $size -t $partition_type -l "$label" -i $partition_id /dev/sda"
    b=$((b + size))
}

for i in {0..10}
do
add_partition ${type[i]} ${label[i]} ${id[i]} ${size[i]}
done

s=$((end-b))
sudo cgpt add -b $b -s $s -t data -l "STATE" -i 1

# Set boot priorities
sudo cgpt add -i 2 -S 0 -T 15 -P 15 /dev/sda
sudo cgpt add -i 4 -S 0 -T 15 -P 0 /dev/sda
sudo cgpt add -i 6 -S 0 -T 15 -P 0 /dev/sda

# Bootloader setup
sudo cgpt boot -p -i 12 /dev/sda
sudo cgpt add -i 12 -B 0 /dev/sda

# Show final partition table
sudo cgpt show /dev/sda
