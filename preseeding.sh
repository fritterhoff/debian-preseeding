#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

BASE_FILE=debian-10.7.0-amd64-netinst.iso

generate(){
        echo -e "# ----\n# Auto generated script\n# ----" > preseed.cfg
        cat preseed-base.cfg >> preseed.cfg
        cat $2 >> preseed.cfg
        cat partition-schema.cfg >> preseed.cfg
        rm -rf isofiles
        apt install -y xorriso isolinux
        xorriso -osirrox on -indev $BASE_FILE -extract / isofiles
        chmod +w -R isofiles/install.amd/
        gunzip isofiles/install.amd/initrd.gz
        echo preseed.cfg | cpio -H newc -o -A -F isofiles/install.amd/initrd
        gzip isofiles/install.amd/initrd
        chmod -w -R isofiles/install.amd/
        cd isofiles
        chmod +w md5sum.txt
        find -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > md5sum.txt
        chmod -w md5sum.txt
        cd ..
        xorriso -as mkisofs -o preseed-$1-$BASE_FILE \
                -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
                -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot \
                -boot-load-size 4 -boot-info-table isofiles
}

wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.7.0-amd64-netinst.iso

generate bios bios-header.cfg
generate uefi uefi-header.cfg