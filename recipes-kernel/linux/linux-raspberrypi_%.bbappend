FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://enable_mtd_phram.cfg \
    file://enable_gpio_sysfs.cfg \
    file://reserved-memory-phram-arm.dtsi \
    file://reserved-memory-phram-arm64.dtsi \
"

# Allocate "reserved-memory" region for PHRAM (32-bit address space)
allocate_phram_area_32bit() {
	export MEMORY_ADDR=`echo "${QUINCE_PHRAM_ADDR}" | sed 's/^0x//'`

	sed -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@MEMORY_ADDR@@/${MEMORY_ADDR}/" \
        "${WORKDIR}/reserved-memory-phram-arm.dtsi" >> "$1"
}

# Allocate "reserved-memory" region for PHRAM (64-bit address space)
allocate_phram_area_64bit() {
	export MEMORY_ADDR=`echo "${QUINCE_PHRAM_ADDR}" | sed 's/^0x//'`

	sed -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@MEMORY_ADDR@@/${MEMORY_ADDR}/" \
        "${WORKDIR}/reserved-memory-phram-arm64.dtsi" >> "$1"
}

do_configure:prepend() {
	for dtb in ${RPI_KERNEL_DEVICETREE}; do
		DTS=`echo "${dtb}" | sed 's/dtb$/dts/'`
		echo "Revert ${S}/arch/${ARCH}/boot/dts/${DTS}"
		git --git-dir=${S}/.git --work-tree=${S} checkout arch/${ARCH}/boot/dts/${DTS}
		if [ "${QUINCE_PHRAM}" != "0" ]; then
			echo "Customize ${S}/arch/${ARCH}/boot/dts/${DTS}"
			if [ "${QUINCE_BITS_OF_ADDRESS_SPACE}" == "64" ]; then
				allocate_phram_area_64bit ${S}/arch/${ARCH}/boot/dts/${DTS}
			else
				allocate_phram_area_32bit ${S}/arch/${ARCH}/boot/dts/${DTS}
			fi
		fi
	done
}

KERNEL_MODULE_AUTOLOAD:rpi += "${KERNEL_MODULES}"

