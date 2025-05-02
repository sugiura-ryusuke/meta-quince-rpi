#!/bin/sh

# This script is only called from do_populate_lic_deploy:append() of image recipes


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi

# Confirm the number of arguments
if [ $# -ne 9 ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


# example
#   QUINCE_DEPLOY_DIR      : deploy-quince-image-minimal-raspberrypi3-64
#   IMAGE_BASENAME         : quince-image-minimal
#   MACHINE                : raspberrypi3-64
#   IMAGE_LINK_NAME        : quince-image-minimal-raspberrypi3-64.rootfs
#   QUINCE_ROOTFS_IMG_FILE : rootfs.img
#   DEPLOY_DIR_IMAGE       : tmp/deploy/images/raspberrypi3-64
#   LICENSE_IMAGE_DIR      : tmp/deploy/licenses/raspberrypi3_64/quince-image-minimal-raspberrypi3-64.rootfs
#   BUILDHISTORY_DIR       : buildhistory
#   BUILDHISTORY_DIR_IMAGE : buildhistory/images/raspberrypi3_64/glibc/quince-image-minimal

SCRIPT_DIR=$(dirname `readlink -f "$0"`)
QUINCE_DEPLOY_DIR=$1
IMAGE_BASENAME=$2
MACHINE=$3
IMAGE_LINK_NAME=$4
QUINCE_ROOTFS_IMG_FILE=$5
DEPLOY_DIR_IMAGE=$6
LICENSE_IMAGE_DIR=$7
BUILDHISTORY_DIR=$8
BUILDHISTORY_DIR_IMAGE=$9


rm -rf ${QUINCE_DEPLOY_DIR}


mkdir -p ${QUINCE_DEPLOY_DIR}
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_BASENAME}.env ${QUINCE_DEPLOY_DIR}
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.manifest ${QUINCE_DEPLOY_DIR}
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.testdata.json ${QUINCE_DEPLOY_DIR}
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.wic.bmap ${QUINCE_DEPLOY_DIR}
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.wic.bz2 ${QUINCE_DEPLOY_DIR}
cp ${SCRIPT_DIR}/flash-wic-image.sh ${QUINCE_DEPLOY_DIR}
cp ${SCRIPT_DIR}/write-sdcard.sh ${QUINCE_DEPLOY_DIR}


mkdir -p ${QUINCE_DEPLOY_DIR}/boot
if [ -e ${DEPLOY_DIR_IMAGE}/boot.scr ]; then
	cp ${DEPLOY_DIR_IMAGE}/boot.scr ${QUINCE_DEPLOY_DIR}/boot
fi
if [ -e ${DEPLOY_DIR_IMAGE}/bootfiles/cmdline.txt ]; then
	cp ${DEPLOY_DIR_IMAGE}/bootfiles/cmdline.txt ${QUINCE_DEPLOY_DIR}/boot
fi
if [ -e ${DEPLOY_DIR_IMAGE}/bootfiles/config.txt ]; then
	cp ${DEPLOY_DIR_IMAGE}/bootfiles/config.txt ${QUINCE_DEPLOY_DIR}/boot
fi
if [ -e ${DEPLOY_DIR_IMAGE}/Image ]; then
	cp ${DEPLOY_DIR_IMAGE}/Image ${QUINCE_DEPLOY_DIR}/boot
fi
if [ -e ${DEPLOY_DIR_IMAGE}/u-boot.bin ]; then
	cp ${DEPLOY_DIR_IMAGE}/u-boot.bin ${QUINCE_DEPLOY_DIR}/boot
fi


mkdir -p ${QUINCE_DEPLOY_DIR}/boot/overlays
DTBO_FILES=`find ${DEPLOY_DIR_IMAGE}/*.dtbo -type f`
cp ${DTBO_FILES} ${QUINCE_DEPLOY_DIR}/boot/overlays

DTB_FILES=`find ${DEPLOY_DIR_IMAGE}/*.dtb -type f`
cp ${DTB_FILES} ${QUINCE_DEPLOY_DIR}/boot
if [ -e ${QUINCE_DEPLOY_DIR}/boot/overlay_map.dtb ]; then
	mv ${QUINCE_DEPLOY_DIR}/boot/overlay_map.dtb ${QUINCE_DEPLOY_DIR}/boot/overlays
fi


mkdir -p ${QUINCE_DEPLOY_DIR}/rootfs
cp ${DEPLOY_DIR_IMAGE}/${IMAGE_LINK_NAME}.ext4 ${QUINCE_DEPLOY_DIR}/rootfs/${QUINCE_ROOTFS_IMG_FILE}


mkdir -p ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR}/metadata-revs ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/build-id.txt ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/depends.dot ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/files-in-image.txt ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/image-info.txt ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/installed-package-names.txt ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/installed-packages.txt ${QUINCE_DEPLOY_DIR}/buildhistory
cp ${BUILDHISTORY_DIR_IMAGE}/installed-package-sizes.txt ${QUINCE_DEPLOY_DIR}/buildhistory


mkdir -p ${QUINCE_DEPLOY_DIR}/manifest
cp ${LICENSE_IMAGE_DIR}/image_license.manifest ${QUINCE_DEPLOY_DIR}/manifest
cp ${LICENSE_IMAGE_DIR}/license.manifest ${QUINCE_DEPLOY_DIR}/manifest
cp ${LICENSE_IMAGE_DIR}/package.manifest ${QUINCE_DEPLOY_DIR}/manifest

