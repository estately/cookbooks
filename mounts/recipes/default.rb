#
# Cookbook Name:: mounts
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

node.mounts.each do |mount_info|

  mount mount_info['mount_point'] do
    device      mount_info[ 'device'      ]
    device_type mount_info[ 'device_type' ] || :uuid
    fstype      mount_info[ 'fstype'      ] || 'ext4'
    options     mount_info[ 'options'     ] || 'defaults'
    dump        mount_info[ 'dump'        ] || 0
    pass        mount_info[ 'pass'        ] || 2

    action mount_info['action'] || [:mount, :enable]
  end

end
