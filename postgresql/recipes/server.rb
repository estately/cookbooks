#
# Cookbook Name:: postgresql
# Recipe:: server
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

###
# Let's install some packages, shall we?
#
include_recipe "postgresql::client"
package "postgresql"

###
# Configure the postgresql service
#
service "postgresql" do
  service_name "postgresql-8.4"
  supports :restart => true, :status => true, :reload => true
  action :nothing
end

###
# and set up the config directory
#
CONFIG_DIR = "/etc/postgresql/8.4/main/"
directory CONFIG_DIR do
  owner "postgres"
  group "postgres"
  mode  0755

  recursive true

  not_if "test -d #{CONFIG_DIR}"
end

###
# remove some default files we don't use
#
file( CONFIG_DIR + "environment"   ) { action :delete; backup false }
file( CONFIG_DIR + "pg_ctl.conf"   ) { action :delete; backup false }

###
# start.conf
#
file CONFIG_DIR + "start.conf" do
  owner "postgres"
  group "postgres"
  mode  0644

  backup false

  # the file should contain just the word "auto"
  content "auto\n"
end

###
# pg_hba.conf
#
template CONFIG_DIR + "pg_hba.conf" do
  owner "postgres"
  group "postgres"
  mode  0640

  notifies :reload, resources(:service => "postgresql")

  variables(
    :networks => search(:networks)
  )
end

###
# pg_ident.conf
#
template CONFIG_DIR + "pg_ident.conf" do
  owner "postgres"
  group "postgres"
  mode  0640

  notifies :reload, resources(:service => "postgresql")

  variables(
    :users => search(:users).map {|u| u[:id] }
  )
end

###
# postgresql.conf
#
template CONFIG_DIR + "postgresql.conf" do
  owner "postgres"
  group "postgres"
  mode  0644

  notifies :restart, resources(:service => "postgresql")
end

###
# /etc/sysctl.d/60-postgresql-tuning.conf
#
template "/etc/sysctl.d/60-postgresql-tuning.conf" do
  owner "root"
  group "root"
  mode  0644

  variables(
    :shmmax => node.sysctl.shmmax,
    :shmall => node.sysctl.shmmax / 4096
  )
end
