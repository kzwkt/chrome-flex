# syntax cgpt add -i partition_no -b block_start -s size_in_sectors -t cros_partition_type  -l cros_label  /device/address 

# RW Firmware (8 MiB, starts at sector 32768)
# 32768 sector = 16 mb
sudo cgpt add -i 11 -b 32768 -s 16384 -t firmware -l "RWFW" /dev/sda
# next sector=b+s=32768 + 16384 = 49152
# Kernel C (512 B, aligned to 4K)
sudo cgpt add -i 6 -b 49152 -s 8 -t kernel -l "KERN-C" /dev/sda
# next sector=49152+8=49160
# Rootfs C (1 GiB, aligned to 4K)
sudo cgpt add -i 7 -b 49160 -s 2097152 -t rootfs -l "ROOT-C" /dev/sda
# next sector=49160+2097152=2146312
# Reserved 9 (512 B, aligned to 4K)
sudo cgpt add -i 9 -b 2146312 -s 8 -t reserved -l "reserved" /dev/sda
# next sector=2146320
# Reserved 10 (512 B, aligned to 4K)
sudo cgpt add -i 10 -b 2146320 -s 8 -t reserved -l "reserved" /dev/sda
# next sector=2146320+8
# Kernel A (64 MiB, aligned to 4K)
sudo cgpt add -i 2 -b 2146328 -s 131072 -t kernel -l "KERN-A" /dev/sda
# next sector=2146320+2146320
# Kernel B (64 MiB, aligned to 4K)
sudo cgpt add -i 4 -b 2277400 -s 131072 -t kernel -l "KERN-B" /dev/sda
# next sector=131072+131072=2408472
# OEM Customization (16 MiB, aligned to 4K)
sudo cgpt add -i 8 -b 2408472 -s 32768 -t data -l "OEM" /dev/sda
# next sector=2408472+32768=2441240
# EFI System Partition (64 MiB, aligned to 4K)
sudo cgpt add -i 12 -b 2441240 -s 131072 -t efi -l "EFI-SYSTEM" /dev/sda
# next sector=2441240+131072=2572312
# Rootfs B (4 GiB, aligned to 4K)
sudo cgpt add -i 5 -b 2572312 -s 8388608 -t rootfs -l "ROOT-B" /dev/sda
# next sector=2572312+8388608=10960920
# Rootfs A (4 GiB, aligned to 4K)
sudo cgpt add -i 3 -b 10960920 -s 8388608 -t rootfs -l "ROOT-A" /dev/sda
# next sector=10960920+8388608=19349528
# STATE Partition (Fixed 50GB, aligned to 4K)
sudo cgpt add -i 1 -b 19349528 -s 104857600 -t data -l "STATE" /dev/sda
# next sector= 19349528+104857600=124207128

# Set boot priorities
sudo cgpt add -i 2 -S 0 -T 15 -P 15 /dev/sda
sudo cgpt add -i 4 -S 0 -T 15 -P 0 /dev/sda
sudo cgpt add -i 6 -S 0 -T 15 -P 0 /dev/sda

# Bootloader setup
sudo cgpt boot -p -i 12 /dev/sda
sudo cgpt add -i 12 -B 0 /dev/sda

# Show final partition table
sudo cgpt show /dev/sda
