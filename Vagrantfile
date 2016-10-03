# -*- mode: ruby -*-
# vi: set ft=ruby :
require "yaml"
settings = YAML.load_file "Vagrant.yml"
Vagrant.require_version settings["require_version"]
settings["required_plugins"].each do |plugin|
  system "echo Trying to install #{plugin} ... && vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end
Vagrant.configure(2) do |config|
  config.vm.box = settings["box_name"]
  config.vm.provider :virtualbox do |provider|
    provider.memory = settings["memory"]
    provider.cpus = settings["cpus"]
  end
  if settings.key?("synced_folder")
    settings["synced_folder"].each_pair do |key, folder|
      config.vm.synced_folder folder["from"], folder["to"],
        mount_options: folder.key?("mount_options") ? folder["mount_options"] : []
    end
  end
  config.vm.network :private_network, type: "dhcp"
  config.vm.hostname = settings["host_name"]
end
