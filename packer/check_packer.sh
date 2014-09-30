#!/bin/bash

set -e

# check if packer is installed
if type packer >/dev/null 2>&1; then
    echo "found packer..."
elif type .packer/packer >/dev/null 2>&1; then
    echo "found packer..."
    export PATH=$PATH:`pwd`/.packer
else
    echo "getting packer...";
    wget -q https://dl.bintray.com/mitchellh/packer/0.6.1_linux_amd64.zip
    unzip -q 0.6.1_linux_amd64.zip -d .packer
    rm 0.6.1_linux_amd64.zip
    export PATH=$PATH:`pwd`/.packer
fi
