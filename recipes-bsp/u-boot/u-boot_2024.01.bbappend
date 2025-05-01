FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://disable_usb.cfg \
    file://disable_video.cfg \
    file://u-boot_2024.01-fix_build_error_when_config_video_is_disabled_for_raspberry_pi.patch \
    file://u-boot_2024.01-disable_load_lmb_check.patch \
"

