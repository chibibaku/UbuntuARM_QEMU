#!/bin/bash


echo " == ====================================== == "
echo " ==    Welcome to UbuntuARM VM maker !!    == "
echo " ==    This script is 100% opens-source    == "
echo " == If find bug(s) send it to github issue == "
echo " == ====================================== == "
echo " "


echo -n "Please input VM username : "
read username
if [ "$username" = "" ] ; then
  echo "Do not leave this field empty!"
  exit
fi
echo -n "Please input VM password : "
read password
if [ "$password" = "" ] ; then
  echo "Do not leave this field empty!"
  exit
fi

echo ""

echo "Update package lists..."
sudo apt update &> /dev/null
echo "Install Qemu..."
sudo apt install -y qemu-system-arm &> /dev/null
echo "Install cloud-image-utils..."
sudo apt install -y cloud-image-utils &> /dev/null

echo ""

echo "Wget UbuntuARM Image... (Its will takes few minutes)"
wget -O ubuntuARM.img http://ubuntutym2.u-toyama.ac.jp/cloud-images/releases/18.04/release/ubuntu-18.04-server-cloudimg-arm64.img &> /dev/null
echo "Wget QemuEFI file..."
wget https://releases.linaro.org/components/kernel/uefi-linaro/latest/release/qemu64/QEMU_EFI.fd &> /dev/null

echo ""

echo "Make EFI as mountable image file..."
dd if=/dev/zero of=flash0.img bs=1M count=64 &> /dev/null
dd if=QEMU_EFI.fd of=flash0.img conv=notrunc &> /dev/null
dd if=/dev/zero of=flash1.img bs=1M count=64 &> /dev/null

echo ""

echo "Generating cloud-init file from Username & Password..."
touch cloud.txt
echo "#cloud-config" >> cloud.txt
echo "user: $username" >> cloud.txt
echo "password: $password" >> cloud.txt
echo "chpasswd: { expire: False }" >> cloud.txt
echo "ssh_pwauth: True" >> cloud.txt
cloud-localds --disk-format qcow2 cloud.img cloud.txt &> /dev/null

echo ""

echo "Configure start.sh..."
chmod +x ./start.sh

echo ""

echo "Remove trash file..."
rm cloud.txt
rm QEMU_EFI.fd
#sudo apt purge -y cloud-image-utils

echo ""

echo "All tasks done! ./start.sh to start VM"