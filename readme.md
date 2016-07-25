# Create ubuntu boxes with packer
Templates for generating ubuntu desktop boxes. this is a fork of [flomotlik/packer-example][1], and highly adapted from [boxcutter/ubuntu][2], removing the non essentials.

Specs for vm:

* 2048MB RAM and 1 CPU
* 50GB disk size
* 256MB of vram

# Build
```
packer build -var-file=ubuntu_1604.json ubuntu.json
```
To install the dev for dev packages run following command after creating the desktop output:
```
packer build -var-file=ubuntu_1604.json ubuntu_dev.json
```

[1]: https://github.com/flomotlik/packer-example
[2]: https://github.com/boxcutter/ubuntu
