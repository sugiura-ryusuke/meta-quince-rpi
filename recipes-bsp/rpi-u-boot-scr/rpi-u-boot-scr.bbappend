FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://boot.cmd.in"

do_compile() {
	sed -e "s/@@KERNEL_IMAGETYPE@@/${KERNEL_IMAGETYPE}/" \
        -e "s/@@KERNEL_BOOTCMD@@/${KERNEL_BOOTCMD}/" \
        -e "s/@@BOOT_MEDIA@@/${BOOT_MEDIA}/" \
        -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@QUINCE_ROOTFS_IMG_FILE@@/${QUINCE_ROOTFS_IMG_FILE}/" \
        -e "s/@@QUINCE_OPT_IMG_FILE@@/${QUINCE_OPT_IMG_FILE}/" \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
	mkimage -A ${UBOOT_ARCH} -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" boot.scr
}

