#
# Cookbook Name:: motd
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

package "figlet"

###
# Remove the silly "welcome to ubuntu" stuff and replace with the
# hostname
#

file( "/etc/update-motd.d/10-help-text" ) { action :delete }
cookbook_file "/etc/update-motd.d/00-header" do
  owner "root"
  group "root"
  mode  0755
end

###
# Describe the server
#

template "/etc/update-motd.d/10-chef-info" do
  owner "root"
  group "root"
  mode  0755

  roles, recipes = node.run_list.partition {|rli| rli.role? }

  variables(
    :roles   => roles,
    :recipes => recipes
  )

end
