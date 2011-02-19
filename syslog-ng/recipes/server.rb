#
# Cookbook Name:: syslog-ng
# Recipe:: server
#
# Copyright 2010, Estately, Inc.
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

include_recipe "syslog-ng::default"

service "syslog-ng" do
  supports :restart => true, :reload => true
  action :nothing
end

# create the config directory
directory "/etc/syslog-ng/conf.d" do
  owner "root"
  group "root"
  mode 0755
end

# create the log directory
directory "/var/log/remote" do
  owner "root"
  group "root"
  mode 0755
end

# configuration!
template "/etc/syslog-ng/syslog-ng.conf" do
  owner "root"
  group "root"
  mode 0644

  notifies :restart, resources( :service => "syslog-ng" )
end
