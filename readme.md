# ubuntu-box creation with packer
templates for generating ubuntu desktop boxes. this is a fork of [flomotlik/packer-example][1], and highly adapted from [boxcutter/ubuntu][2], removing non essentials.

specs for vm:

* 8092MB RAM and 2 CPUs
* 20GB disk size

# create box
```
packer build -only virtualbox-iso -var-file=ubuntu_1504_desktop.json ubuntu.json
```

# directory structure

* ```packer``` directory contains a script to check/install packer from source, as well as ```json``` files for different ubuntu boxes.
* ```scripts``` directory contains scripts to setup ssh, update and other tools for the virtual machine.
```http/preseed.cfg``` contains general pre-configuration for the ubuntu virtual machine. here you can change time-zone, keyboard, update-policy, etc...

[1]: https://github.com/flomotlik/packer-example
[2]: https://github.com/boxcutter/ubuntu
