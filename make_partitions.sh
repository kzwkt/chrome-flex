# syntax cgpt add -i partition_no -b block_start -s size_in_sectors -t cros_partition_type  -l cros_label  /device/address 

# RW Firmware (8 MiB, starts at sector 32768)
sudo cgpt add -i 11 -b 32768 -s 16384 -t firmware -l "RWFW" /dev/sda

# Kernel C (512 B, aligned to 4K)
sudo cgpt add -i 6 -b 49152 -s 8 -t kernel -l "KERN-C" /dev/sda

# Rootfs C (1 GiB, aligned to 4K)
sudo cgpt add -i 7 -b 49160 -s 2097152 -t rootfs -l "ROOT-C" /dev/sda

# Reserved 9 (512 B, aligned to 4K)
sudo cgpt add -i 9 -b 2146312 -s 8 -t reserved -l "reserved" /dev/sda

# Reserved 10 (512 B, aligned to 4K)
sudo cgpt add -i 10 -b 2146320 -s 8 -t reserved -l "reserved" /dev/sda

# Kernel A (64 MiB, aligned to 4K)
sudo cgpt add -i 2 -b 2146328 -s 131072 -t kernel -l "KERN-A" /dev/sda

# Kernel B (64 MiB, aligned to 4K)
sudo cgpt add -i 4 -b 2277400 -s 131072 -t kernel -l "KERN-B" /dev/sda

# OEM Customization (16 MiB, aligned to 4K)
sudo cgpt add -i 8 -b 2408472 -s 32768 -t data -l "OEM" /dev/sda

# EFI System Partition (64 MiB, aligned to 4K)
sudo cgpt add -i 12 -b 2441240 -s 131072 -t efi -l "EFI-SYSTEM" /dev/sda

# Rootfs B (4 GiB, aligned to 4K)
sudo cgpt add -i 5 -b 2572312 -s 8388608 -t rootfs -l "ROOT-B" /dev/sda

# Rootfs A (4 GiB, aligned to 4K)
sudo cgpt add -i 3 -b 10960920 -s 8388608 -t rootfs -l "ROOT-A" /dev/sda

# STATE Partition (Fixed 50GB, aligned to 4K)
sudo cgpt add -i 1 -b 19349528 -s 104857600 -t data -l "STATE" /dev/sda

# Set boot priorities
sudo cgpt add -i 2 -S 0 -T 15 -P 15 /dev/sda
sudo cgpt add -i 4 -S 0 -T 15 -P 0 /dev/sda
sudo cgpt add -i 6 -S 0 -T 15 -P 0 /dev/sda

# Bootloader setup
sudo cgpt boot -p -i 12 /dev/sda
sudo cgpt add -i 12 -B 0 /dev/sda

# Show final partition table
sudo cgpt show /dev/sda
