# ubuntu-box creation with packer
this generates barebone ubuntu base boxes. this is a fork of [flomotlik/packer-example][1], and highly adapted from [boxcutter/ubuntu][2], removing non essentials.

specs for vm:

* Ubuntu 14.04.3 Server LTS or Ubuntu 12.04.5 Server LTS
* 2048MB RAM and 1 CPUs
* 20GB disk size

# create box
simply run

```
packer build -only virtualbox-iso -var-file=ubuntu_1404_desktop.json ubuntu.json
```

# directory structure

* ```packer``` directory contains a script to check/install packer from source, as well as ```json``` files for different ubuntu boxes.
* ```scripts``` direcotry contains scripts to setup ssh and users for the virutal machine.
```http/preseed.cfg``` contains general preconfiguration for the ubuntu virtual machine. here you can change time-zone, keyboard, update-policy, etc...
* ```Vagrantfile``` is an example to run a machine you build.

[1]: https://github.com/flomotlik/packer-example
[2]: https://github.com/boxcutter/ubuntu
