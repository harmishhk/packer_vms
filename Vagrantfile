# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "ubuntu_1404.box"
    config.vm.hostname = "ubuntu-1404"
    config.vm.provider :virtualbox do |vb|
      vb.name = "ubuntu_1404"
    end
    config.vm.network :private_network, ip: "192.168.50.5"
    config.vm.synced_folder "src/", "/srv/website", disabled: true
end
