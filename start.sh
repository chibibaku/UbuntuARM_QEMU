qemu-system-aarch64 -m 4096 -smp 4 -cpu cortex-a57 -M virt -nographic \
  -pflash flash0.img \
  -pflash flash1.img \
  -drive if=none,file=ubuntuARM.img,id=hd0 \
  -device virtio-blk-device,drive=hd0 \
  -drive if=none,id=cloud,file=cloud.img \
  -device virtio-blk-device,drive=cloud \
  -device virtio-net-device,netdev=user0