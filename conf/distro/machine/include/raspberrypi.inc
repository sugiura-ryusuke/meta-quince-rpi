#
# Quince Distribution - Common configuration for Raspberry Pi
#

# References
#
# * Raspberry Pi  Configuration
#     https://www.raspberrypi.com/documentation/computers/configuration.html
#
# * Raspberry Pi  config.txt
#     https://www.raspberrypi.com/documentation/computers/config_txt.html
#
# * Raspberry Pi bootloader/GPU firmware  Device Tree overlays
#     https://github.com/raspberrypi/firmware/blob/master/boot/overlays/README
#
# * Yocto/OE BSP layer for the Raspberry Pi boards  Optional build configuration
#     https://github.com/agherzan/meta-raspberrypi/blob/master/docs/extra-build-config.md

# Have u-boot load kernel image,
RPI_USE_U_BOOT = "1"

# Kernel image type
KERNEL_IMAGETYPE = "Image"

# u-boot command
KERNEL_BOOTCMD = "booti"

# Enable I2C
#   dtparam=i2c1=on
#   dtparam=i2c_arm=on
ENABLE_I2C = "1"

# Enable SPI bus
#   dtparam=spi=on
ENABLE_SPI_BUS = "1"

# Enable UART (Assign Primary UART to GPIO14[TXD] and GPIO15[RXD])
#  enable_uart=${ENABLE_UART}
ENABLE_UART = "1"

# Enable One-Wire Interface
#   dtoverlay=w1-gpio
ENABLE_W1 = "1"

