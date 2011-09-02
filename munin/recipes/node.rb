#
# Cookbook Name:: munin
# Recipe:: node
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

package "munin-node"

service "munin-node" do
  supports :restart => true
  action :enable
end

template "/etc/munin/munin-node.conf" do
  owner "root"
  group "root"
  mode  0644

  notifies :restart, resources(:service => "munin-node")

  variables(
    :networks => search(:networks)
  )
end

########################################################################
### Clean Up Defaults
########################################################################

# default plugins that we want to disable
plugins_to_disable = %w(
  apt cpuspeed fw_conntrack fw_forwarded_local fw_packets http_loadtime
)

# default plugins that we want to remain enabled... note that
# wildcard plugins are specified as link_name:plugin_name
plugins_to_enable = %w(
  acpi cpu df df_inode diskstats entropy forks if_eth0:if_
  if_err_eth0:if_err_ interrupts iostat iostat_ios irqstats load memory
  open_files open_inodes proc_pri processes swap threads uptime users
  vmstat
)

# additional plugins to enable
plugins_to_enable << "apt_all"
plugins_to_enable << "tcp"

########################################################################
### Enable / Disable Plugins
########################################################################

plugins_to_disable.each do |plugin|
  munin_plugin( plugin ) { action :disable }
end

plugins_to_enable.each do |plugin|
  link, plugin_name = plugin.split(':')
  munin_plugin( link ) { plugin plugin_name if plugin_name }
end

########################################################################
### Magical Plugin Detection
########################################################################

existing_munin_recipes = node.
  cookbook_collection['munin'].
  fully_qualified_recipe_names

recipes = node.run_list.expand( node.chef_environment ).recipes
roles = node.run_list.expand( node.chef_environment ).roles

(recipes + roles).flatten.each do |recipe|
  recipe_name = "munin::#{recipe.gsub /::/, '_'}"
  include_recipe recipe_name if existing_munin_recipes.include?( recipe_name )
end
