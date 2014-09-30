# ubuntu-box creation with packer
this generates barebone ubuntu vagrant base boxes. this is a fork of [flomotlik/packer-example][1], removing non essentials.

specs for vm:

* Ubuntu 14.04.1 Server LTS
* 2048MB RAM and 4 CPUs
* 32GB disk size
* no VirtualBox Guest Additions installed. can be installed via `vagrant-vbguest` plugin.

# create box
simply run

```
./create_box
```

# directory structure

* ```packer``` directory contains a script to check/install packer from source, as well as ```json``` files for different ubuntu boxes.
* ```scripts``` direcotry contains scripts to setup ssh and users for the virutal machine.
```http/preseed.cfg``` contains general preconfiguration for the ubuntu virtual machine. here you can change time-zone, keyboard, update-policy, etc...
* ```Vagrantfile``` is an example to run a machine you build.

[1]: https://github.com/flomotlik/packer-example
