# -*- mode: ruby -*-
# vi: set ft=ruby :

require './scripts/defaults'

instances = ['prometheus', 'LAMP', 'alertmanager']

Vagrant.configure(2) do |config|
  config.vm.synced_folder ".", "/vagrant"
  instances.each_with_index.map do |item, index|
    config.vm.define "#{item}" do |node|
      node.vm.box = VIRBOX
      node.vm.provider "virtualbox" do |vbox|
        vbox.gui = false
        vbox.memory = RAM + 512
        vbox.name = item
        vbox.cpus = 2
      end
      node.vm.hostname = item + DOMAIN
      node.vm.network 'private_network', ip: NETIPS + "#{index + 12}", netmask: NETMASK
      node.vm.provision "shell", path: "scripts/hosts.sh", args: [NETIPS, DOMAIN, 12]
      node.vm.provision "shell", path: "scripts/#{item}.sh"
      node.vm.provision "shell", path: "scripts/node_exporter.sh"
    end
  end
end
