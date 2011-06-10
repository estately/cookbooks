#
# Cookbook Name:: munin
# Recipe:: master
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

include_recipe 'munin::node'
package "munin"

# create htmldir
directory node.munin.htmldir do
  owner "munin"
  group "munin"
  mode  0755
  recursive true
end

# render the munin config
template "/etc/munin/munin.conf" do
  owner "root"
  group "root"
  mode  0644

  hosts = search(:node, 'roles:monitored')

  variables :hosts          => hosts + node.munin.additional_hosts,
            :alerts_enabled => node[:munin][:alerts][:enabled],
            :email_address  => node[:munin][:alerts][:email_address],
            :email_subject  => node[:munin][:alerts][:email_subject],
            :by_host        => node[:munin][:alerts][:by_host],
            :thresholds     => node[:munin][:alerts][:thresholds],
            :nagios_enabled => node[:munin][:nagios][:enabled],
            :nsca_host      => node[:munin][:nagios][:nsca_host]
  notifies :restart, "service[munin-node]"
end

########################################################################
### Enable the webserver
########################################################################

include_recipe "apache2"

munin_domain = [ node.munin.hostname, node.munin.domain ].join('.')

### install the ssl cert
if node.munin.ssl_enabled
  include_recipe "apache2::mod_ssl"
  cookbook_file "#{node.apache.dir}/ssl/#{munin_domain}.pem" do
    owner "root"
    group "root"
    mode  0600
  end
end

### install the digest password file
if node.munin.auth_enabled
  include_recipe "apache2::mod_auth_digest"
  template "#{node.apache.dir}/#{munin_domain}.digest_passwds" do
    source "htpasswd.erb"
    owner "root"
    group "www-data"
    mode  0640

    variables :users => search( "users" )
  end
end

web_app "munin" do
  server_name    munin_domain
  server_aliases node.munin.hostname

  docroot node.munin.htmldir

  action :enable
end
