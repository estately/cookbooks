#
# Cookbook Name:: accounts
# Recipe:: users
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

# libshadow is required to set passwords
package "libshadow-ruby1.8"

# remove the bootstrap user
user("bootstrap") do
  action :remove

  # don't try to run if bootstrap is still logged in
  not_if "who | grep bootstrap"
end

# create users from the users databag
search( "users" ).sort_by {|u| u[:uid] }.each do |user|

  user user[:id] do
    comment  user[ :name     ]
    uid      user[ :uid      ]
    shell    user[ :shell    ] || "/bin/bash"
    password user[ :password ] || "$1$oBTQd/WJ$UBd0XfleEOk3.ZGZF9Ue30"
    home     user[ :home     ] || "/home/#{user[:id]}"

    supports :manage_home => true

    action [ :create, :manage ]
  end

end
