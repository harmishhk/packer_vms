# create ubuntu boxes with packer
templates for generating ubuntu desktop boxes. this is a fork of [flomotlik/packer-example][1], and highly adapted from [boxcutter/ubuntu][2], removing the non essentials.

specs for vm:

* 8092MB RAM and 2 CPUs
* 40GB disk size
* 256MB of vram

# create box
```
packer build -var-file=ubuntu_1504_desktop.json ubuntu.json
```
to install the dev for dev packages run following command after creating the desktop output
```
packer build -var-file=ubuntu_1504_desktop.json ubuntu_dev.json
```

[1]: https://github.com/flomotlik/packer-example
[2]: https://github.com/boxcutter/ubuntu
