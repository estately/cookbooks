#
# Cookbook Name:: statsd
# Recipe:: default
#
# Copyright 2011, Blank Pad Development
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

include_recipe "build-essential"
include_recipe "git"

if node[:platform]=="ubuntu"
  package "python-software-properties"
  execute "Add PPA repository" do
    command "sudo add-apt-repository ppa:chris-lea/node.js"
  end
  execute "Update Package List" do
    command "sudo apt-get update"
  end
end

package "nodejs"
package "npm"

execute "install modules" do
  command "sudo npm -g install async temp node-syslog underscore"
  not_if {File.exists?("/usr/lib/node_modules/underscore")}
end

execute "checkout statsd" do
  command "git clone git://github.com/tdtran/statsd"
  creates "/tmp/statsd"
  cwd "/tmp"
end

package "debhelper"

execute "build debian package" do
  command "dpkg-buildpackage -us -uc"
  creates "/tmp/statsd_0.0.1_all.deb"
  cwd "/tmp/statsd"
end

dpkg_package "statsd" do
  action :install
  source "/tmp/statsd_0.0.1_all.deb"
end

template "/etc/statsd/estately-config.js" do
  source "estately-config.js.erb"
  mode 0644
  variables(
    :graphService => node[:statsd][:graphService],
    :graphiteHost => node[:statsd][:graphiteHost],
    :graphitePort => node[:statsd][:graphitePort]
  )

  notifies :restart, "service[statsd]"
end

cookbook_file "/usr/share/statsd/scripts/start" do
  source "upstart.start"
  mode 0755
end

cookbook_file "/etc/init/statsd.conf" do
  source "upstart.conf"
  mode 0644
end

user "statsd" do
  comment "statsd"
  system true
  shell "/bin/false"
end

service "statsd" do
  provider Chef::Provider::Service::Upstart
  action [ :enable, :start ]
end
