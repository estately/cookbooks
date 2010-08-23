#
# Cookbook Name:: munin
# Recipe:: postgresql_server
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

########################################################################
### Setup
########################################################################

# required for postgres plugins
package "libdbd-pg-perl"

# set up default attributes
node.default.postgresql.monitored_databases = []

# configure postgres plugins
template "/etc/munin/plugin-conf.d/postgres" do
  owner "root"
  group "root"
  mode  0644

  notifies :restart, resources(:service => "munin-node")
end

########################################################################
### Install Plugins
########################################################################

standard_plugins = %w(
  postgres_bgwriter postgres_checkpoints postgres_connections_db
  postgres_users postgres_xlog
)
standard_plugins.each {|plugin| munin_plugin plugin }


wildcard_plugins = %w(
  postgres_cache_ postgres_connections_ postgres_locks_
  postgres_querylength_ postgres_scans_ postgres_size_
  postgres_transactions_ postgres_tuples_
)

node.postgresql.monitored_databases.each do |db|
  wildcard_plugins.each do |plugin_name|
    target = plugin_name + db
    munin_plugin( target ) { plugin plugin_name }
  end
end
