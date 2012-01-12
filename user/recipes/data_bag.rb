#
# Cookbook Name:: user
# Recipe:: data_bag
#
# Copyright 2011, Fletcher Nichol
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

bag   = node['user']['data_bag']
users = begin
  data_bag(bag)
rescue => ex
  Chef::Log.info("Data bag #{bag} not found (#{ex}), so skipping")
  []
end

Array(node['users']).each do |i|
  u = data_bag_item(bag, i)
  username = u['username'] || u['id']

  user_account username do
    %w{comment uid gid home shell password system_user manage_home create_group
        ssh_keys ssh_keygen}.each do |attr|
      send(attr, u[attr]) if u[attr]
    end
    action u['action'].to_sym if u['action']
  end
end
