#!/bin/bash

# cros_size:[16k,512b,1g,512b,512b,64m,64m,16m,64m,4g,4g,flexible)
# cgpt add -b start_block -s size_in_blocks -t part_type -l part_label -i part_id part/address
device=${3:-"sda"} 
b=${1:-32768} 
end=${2:-124207128}
sector_size=$(cat /sys/class/block/$device/queue/logical_block_size)
blocksize=${sector_size:-512}
type=(firmware kernel rootfs rootfs reserved reserved kernel data efi rootfs rootfs)
label=("RWFW" "KERN-C" "ROOT-C" "reserved" "reserved" "KERN-A" "KERN-B" "OEM" "EFI-SYSTEM" "ROOT-B" "ROOT-A")
id=(11 6 7 9 10 2 4 8 12 5 3)
size=(16384 8 2097152 8 8 131072 131072 32768 131072 8388608 8388608)

add_partition() {
    local partition_type=$1
    local label=$2
    local partition_id=$3
    local size=$(($4 * 512 / blocksize))
    # cgpt add -b $b -s $size -t $partition_type -l "$label" -i $partition_id /dev/$device
    echo "cgpt add -b $b -s $size -t $partition_type -l "$label" -i $partition_id /dev/$device"
    b=$((b + size))
}

for i in {0..10}
do
add_partition ${type[i]} ${label[i]} ${id[i]} ${size[i]}
done

s=$((end-b))
 cgpt add -b $b -s $s -t data -l "STATE" -i 1 /dev/$device

# Set boot priorities
 cgpt add -i 2 -S 0 -T 15 -P 15 /dev/$device
 cgpt add -i 4 -S 0 -T 15 -P 0 /dev/$device
 cgpt add -i 6 -S 0 -T 15 -P 0 /dev/$device

# Bootloader setup
 cgpt boot -p -i 12 /dev/$device
 cgpt add -i 12 -B 0 /dev/$device

# Show final partition table
 cgpt show /dev/$device
 
# usage
# bash  make_partitions.sh start_sector end_sector devicename_to_install 
# without parameter it will use fallback from begiing address to about 60gb
