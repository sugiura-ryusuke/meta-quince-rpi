# meta-quince-rpi
Customization for Raspberry Pi of Quince distribution

## How To Build

### Build Host Requirement

- Ubuntu 22.04  
- At least 8GB RAM  
- At least 128GB Storage  

### Host Setup (for Ubuntu 22.04)

#### Reconfigure to use bash as default shell for /bin/sh  

```
$ sudo dpkg-reconfigure dash
```

Select "No" when you are asked to use dash as the default system shell.

#### Install the packages needed to build an image  

```
$ sudo apt install build-essential chrpath cpio debianutils diffstat file
$ sudo apt install gawk gcc git iputils-ping libacl1 liblz4-tool locales
$ sudo apt install python3 python3-git python3-jinja2 python3-pexpect python3-pip python3-subunit
$ sudo apt install socat texinfo unzip wget xz-utils zstd
```

#### Install bmaptool for writing a .wic image to a storage device  

```
$ sudo apt install bmap-tools
```

#### Download git-repo  

```
$ git clone https://gerrit.googlesource.com/git-repo
```

### Build Steps

#### Download quince-manifest for Raspberry Pi

```
$ mkdir quince_rpi
$ cd quince_rpi
$ ~/git-repo/repo init -u https://github.com/sugiura-ryusuke/quince-manifest -m rpi.xml -b refs/tags/rpi-5.0.8-2025.5.10
```

#### Download repositories to build Quince distribution for Raspberry Pi  

```
$ ~/git-repo/repo sync
```

#### Setup build environment  

```
$ ./layers/meta-quince-rpi/scripts/setup.sh

layer                 path                                                                    priority
========================================================================================================
core                  /home/dev/quince_rpi/layers/openembedded-core/meta                      5
openembedded-layer    /home/dev/quince_rpi/layers/meta-openembedded/meta-oe                   5
meta-python           /home/dev/quince_rpi/layers/meta-openembedded/meta-python               5
networking-layer      /home/dev/quince_rpi/layers/meta-openembedded/meta-networking           5
filesystems-layer     /home/dev/quince_rpi/layers/meta-openembedded/meta-filesystems          5
lts-u-boot-mixin      /home/dev/quince_rpi/layers/meta-lts-mixins                             6
raspberrypi           /home/dev/quince_rpi/layers/meta-raspberrypi                            9
quince                /home/dev/quince_rpi/layers/meta-quince                                 15
quince-rpi            /home/dev/quince_rpi/layers/meta-quince-rpi                             15
```

#### Build Quince distribution image  

- Build minimal image for Raspberry Pi 5  

```
$ ./build/scripts/build-minimal-raspberrypi5.sh
```

- Build basic image for Raspberry Pi 5  

```
$ ./build/scripts/build-basic-raspberrypi5.sh
```

- Clean build files  

```
$ ./build/scripts/clean-build.sh
```

#### Write image to SD card  

- Create SD card for booting Quince system (minimal image) 

```
$ ./build/deploy-quince-image-minimal-raspberrypi5/write-sdcard.sh
```

- Flash a Wic image onto the SD card (minimal image)  

```
$ ./build/deploy-quince-image-minimal-raspberrypi5/flash-wic-image.sh
```

