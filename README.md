# Packer for Red Hat on QEMU
This project can build a QEMU image for Red Hat, this includes the latest updates for RHEL9.

It will generate a 50GB raw disk with a CIS compliant filesystem setup. It uses virtio (/dev/vda) to prepare the image.

## Requirements
- Packer in your environment. [Install Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli)
- QEMU

## Building the image
### Configuration
In the `config.ini` you need to fill in two variables for the Red Hat Subscription Manager:
- `rhsm_org_id` - Red Hat organization ID
- `rhsm_key` - Activation key that needs to be used
### Building
You can use the `build.py` script to start the build.
```bash
build.py <os>
# Example:
build.py rhel9
```
It will check for the variable template `<os>.variables.pkrvars.hcl`.
