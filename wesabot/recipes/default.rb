#
# Cookbook Name:: wesabot
# Recipe:: default
#
# Copyright 2011, Estately, Inc.
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

include_recipe "runit"

package "git-core"
package "libssl-dev"

package "sqlite3"
package "libsqlite3-dev"
gem_package "sqlite3"

gem_package "bundler"

### check out the bot
git "wesabot-HEAD" do
  repository  "git://github.com/hackarts/wesabot.git"
  destination "/usr/src/wesabot"
  reference   "master"

  action :checkout
end

### run bundler
execute("bundle install") { cwd "/usr/src/wesabot" }

### create the database directory
db_dir = File.dirname node.wesabot.database_path
directory db_dir do
  owner "nobody"
  group "nogroup"
  mode  0755
end

### install the configuration
template "/etc/wesabot.conf" do
  owner "root"
  group "root"
  mode  0644
end

### set up the service
runit_service "wesabot" do
  template_name 'wesabot'
  notifies :restart, resources(:service => "wesabot")
end
