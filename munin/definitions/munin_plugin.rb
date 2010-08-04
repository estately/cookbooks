#
# Cookbook Name:: munin
# Definition:: munin_plugin
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

DEFAULTS = {
  :action => :enable,
  :plugin_dir => "/usr/share/munin/plugins"
}

define :munin_plugin, DEFAULTS do
  # if we create a munin_plugin, we probably want to have
  # munin installed.
  include_recipe "munin::node"

  # some plugins have names like blah_ and are meant to
  # be symlinked to a magical name like blah_eth0... we
  # handle this by allowing the :plugin param
  plugin = params[:plugin] || params[:name]

  link "/etc/munin/plugins/#{params[:name]}" do
    action :delete if params[:action] == :disable

    owner "root"
    group "root"
    to [ params[:plugin_dir], plugin ].join( "/" )

    notifies :restart, resources(:service => "munin-node")
  end

end
