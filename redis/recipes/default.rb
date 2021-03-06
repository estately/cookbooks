#
# Cookbook Name:: redis
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

### Install the OneHub PPA to get Redis 2.2.x
apt_repository "onehub-ppa" do
  uri "http://ppa.launchpad.net/onehub/ppa/ubuntu/"
  key "CCC23219"
  keyserver "keyserver.ubuntu.com"

  distribution "lucid"
  components   %w( main )

  action :add
end

package "redis-server"

service "redis-server" do
  supports [:restart]
  action :enable
end

template "/etc/redis/redis.conf" do
  owner "root"
  group "root"
  mode  0644

  notifies :restart, resources( :service => "redis-server" )
end
