# Automated Debian installation

This installer automatically installs a slim and plain Debian.

Only the configuration of an apt mirror, the hostname and the ip configuration must be done manually. Please notice that the largest available disk will be formated and partionized. The partioning will use LVM2 so resizing some partions afterwards can be done without major strugles.

## Usage

```bash
sudo preseeding.sh
```

Executing the script `preseeding.sh` will generate two isos one for a bios and one for an uefi installation.

## Features

* Manual hostname and ip configuration
* Automatic partioning
* Creation of root user
* No other user
* No window manager, only ssh-server
* Compatible with UEFI and BIOS systems
