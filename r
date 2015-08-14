make clean
make && cp kernel.img /Volumes/boot/ && diskutil unmountDisk /dev/disk2 && echo '******* ALL DONE *******'
