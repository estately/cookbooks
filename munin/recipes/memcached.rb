#
# Cookbook Name:: munin
# Recipe:: postgresql_server
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

package "munin-plugins-extra"
package "libcache-memcached-perl"

%w( rates bytes counters ).each do |dataset|
  target = "memcached_#{dataset}"
  munin_plugin( target ) { plugin "memcached_" }
end
