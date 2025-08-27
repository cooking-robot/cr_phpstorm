#
# Cookbook:: cr_phpstorm
# Recipe:: default
#
# Copyright:: 2025, The Authors, All Rights Reserved.

case node['platform_family']
when 'windows'
  tmp_config = "#{Chef::Config['file_cache_path']}/phpstorm.config".gsub('/', '\\')

  template 'phpstorm-silent.config' do
    source 'silent.config.erb'
    path tmp_config
    action :create
  end
  
  windows_package "PhpStorm #{node['phpstorm']['version']}" do
    action :install
    installer_type :nsis
    source "https://download.jetbrains.com/webide/PhpStorm-#{node['phpstorm']['version']}.exe"
    options "/CONFIG=#{tmp_config}"
  end
  

when 'debian', 'rhel'
  execute 'phpstom install' do
    command 'snap install phpstorm --classic'
    not_if 'snap list | grep phpstorm'
  end
end
