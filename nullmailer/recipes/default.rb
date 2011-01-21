#
# Cookbook Name:: nullmailer
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

# remove postfix, we don't want both
package("postfix") { action :purge }
package "nullmailer"

service "nullmailer" do
  supports [ :start, :stop, :restart, :reload ]
  action :enable
end

file "/etc/mailname" do
  owner "root"
  group "root"
  mode  0644

  content "#{node.nullmailer.mailname}\n"

  notifies :restart, resources(:service => "nullmailer")
end

file "/etc/nullmailer/remotes" do
  owner "root"
  group "root"
  mode  0644

  # dup, lest we mutate the actual attribute value
  remote = node.nullmailer.relayhost.dup
  remote << " smtp"

  if node.nullmailer.username
    remote << " --user=#{node.nullmailer.username}"
  end

  if node.nullmailer.password
    remote << " --pass=#{node.nullmailer.password}"
  end

  content "#{remote}\n"

  notifies :restart, resources(:service => "nullmailer")
end
