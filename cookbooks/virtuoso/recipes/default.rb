#
# Cookbook Name:: virtuoso
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

code_user=node['virtuoso']['code_user']
code_group=node['virtuoso']['code_group']
code_dir=node['virtuoso']['code_dir']
install_dir=node['virtuoso']['install_dir']


apt_package "autoconf" do
  action :install
end
apt_package "automake" do
  action :install
end
apt_package "libtool" do
  action :install
end
apt_package "flex" do
  action :install
end
apt_package "bison" do
  action :install
end
apt_package "gperf" do
  action :install
end
apt_package "gawk" do
  action :install
end
apt_package "m4" do
  action :install
end
apt_package "make" do
  action :install
end
apt_package "openssl" do
  action :install
end
apt_package "libssl-dev" do
  action :install
end

git code_dir do
  repository "git://github.com/openlink/virtuoso-opensource.git"
  revision node['virtuoso']['revision']
  user code_user
  group code_group
  action :sync
end

bash 'compile' do
  user code_user
  group code_group
  cwd code_dir
  environment ({'CFLAGS' => node['virtuoso']['cflags']})
  code <<-EOH
    ./autogen.sh
    ./configure --prefix="#{install_dir}" --program-transform-name="s/isql/isql-v/"
    make
  EOH
  action :run
  notifies :run, "execute[install]"
end
	
execute "install" do
  cwd code_dir
  command 'make install'
  action :nothing
  notifies :run, "bash[add to /usr/bin]"
end
	
bash "add to /usr/bin" do
  code <<-EOH
    ln -s #{install_dir}/bin/virtuoso-t /usr/local/bin/virtuoso-t
    ln -s #{install_dir}/bin/isql-v /usr/local/bin/isql-v
   EOH
  action :nothing
end
