#!/bin/bash

username="user"
password="pass"

echo " == ====================================== == "
echo " ==    Welcome to UbuntuARM VM maker !!    == "
echo " ==    This script is 100% opens-source    == "
echo " == If find bug(s) send it to github issue == "
echo " == ====================================== == "
echo " "


echo -n "Please_input_VM_username(default 'user'):"
read username
echo -n "Please_input_VM_password(default 'pass'):"
read password

echo "Update package lists..."
sudo apt update &> /dev/null
echo "Install Qemu..."
sudo apt install -y qemu-system-arm &> /dev/null
echo "Install cloud-image-utils..."
sudo apt install -y cloud-image-utils &> /dev/null

echo "Wget UbuntuARM Image... (Its will takes few minutes)"
wget -O ubuntuARM.img http://ubuntutym2.u-toyama.ac.jp/cloud-images/releases/18.04/release/ubuntu-18.04-server-cloudimg-arm64.img &> /dev/null
echo "Wget QemuEFI file..."
wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd &> /dev/null

echo "Make EFI as mountable image file..."
dd if=/dev/zero of=flash0.img bs=1M count=64 &> /dev/null
dd if=QEMU_EFI.fd of=flash0.img conv=notrunc &> /dev/null
dd if=/dev/zero of=flash1.img bs=1M count=64 &> /dev/null

echo "Replace Username & Password..."
cp cloud.txt cloud.new.txt  &> /dev/null
sed -e 's/user/$username/' cloud.new.tx &> /dev/null
sed -e 's/password/$password/' cloud.new.txt &> /dev/null
cloud-localds --disk-format qcow2 cloud.img cloud.new.txt &> /dev/null

echo "Configure start.sh"
chmod +x ./start.sh

echo "Remove trash file..."
rm cloud.new.txt
#sudo apt purge cloud-image-utils

echo "All tasks done! ./start.sh to start VM"
