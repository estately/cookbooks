#
# Cookbook Name:: munin
# Recipe:: master
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

include_recipe 'munin::node'
package "munin"

# create htmldir
directory node.munin.htmldir do
  owner "munin"
  group "munin"
  mode  0755
end

# render the munin config
template "/etc/munin/munin.conf" do
  owner "root"
  group "root"
  mode  0644

  hosts = search(:node, 'roles:monitored')
  variables :hosts => hosts + node.munin.additional_hosts
end

########################################################################
### Enable the webserver
########################################################################

include_recipe "nginx"
nginx_site( "default" ) { action :disable }

# do this search outside the nginx_site block, as the block doesn't
# have the correct scope to perform the search
networks = search(:networks).map {|n| n[:cidr] }

nginx_site "munin" do
  action :enable
  variables :networks => networks
end
