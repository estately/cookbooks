#
# Cookbook Name:: pdftk
# Recipe:: default
#
# Copyright 2011, Heavy Water Software Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "build-essential" do
  action :install
end

package "unzip" do
  action :install
end

package "g++" do
  action :install
end

package "gcj" do
  action :install
end

remote_file "/tmp/#{node.pdftk.source}" do
  source node.pdftk.uri
  mode "0644"
  not_if do
      File.exists?("/tmp/#{node.pdftk.source}")
  end
end

execute "Unzipping archive #{node.pdftk.source}" do
  command "cd /tmp; unzip #{node.pdftk.source}"
  not_if "test -d /tmp/#{node.pdftk.dir}"
end

case node['platform']
when "ubuntu","debian"
execute "Building Software" do
   command "cd /tmp/#{node.pdftk.dir}/pdftk; make -f Makefile.Debian"
   not_if "test -f /tmp/#{node.pdftk.dir}/pdftk/pdftk"
end
execute "Installing Software" do
   command "cd /tmp/#{node.pdftk.dir}/pdftk; sudo make -f Makefile.Debian install"
   not_if "test -f /usr/local/bin/pdftk"
end
when "centos","redhat","fedora"
execute "Building Software" do
   command "cd /tmp/#{node.pdftk.dir}/pdftk; make -f Makefile.RedHat"
   not_if "test -f /tmp/#{node.pdftk.dir}/pdftk/pdftk"
end
execute "Installing Software" do
   command "cd /tmp/#{node.pdftk.dir}/pdftk; sudo make -f Makefile.RedHat install"
   not_if "test -f /usr/local/bin/pdftk"
end
end


directory "/opt/local" do
   owner "root"
   group "root"
   mode  "0755"
   action :create
end
directory "/opt/local/bin" do
   owner "root"
   group "root"
   mode  "0755"
   action :create
end
execute "Create custom symlink" do
  command "sudo -i -u root ln -s /usr/local/bin/pdftk /opt/local/bin/pdftk"
  not_if "test -f /opt/local/bin/pdftk"
end
