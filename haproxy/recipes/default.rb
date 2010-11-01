#
# Cookbook Name:: haproxy
# Recipe:: default
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

package("haproxy") { action :install }

# Clean up installed crap
directory "/etc/haproxy/errors" do
  action    :delete
  recursive true
end

file "/etc/default/haproxy" do
  owner "root"
  group "root"
  mode  0644
  content "ENABLED=1\n"
end

# configure a service
service "haproxy" do
  supports [ :restart, :reload, :status ]
  action :enable
end

# install a config
template "/etc/haproxy/haproxy.cfg" do
  owner "root"
  group "root"
  mode 0644

  notifies :restart, resources( :service => "haproxy" )
end
