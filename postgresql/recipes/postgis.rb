#
# Cookbook Name:: postgresql
# Recipe:: postgis
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

package "build-essential"
package "libxml2-dev"

include_recipe "postgresql::server"

package "libpq-dev"
package "postgresql-server-dev-9.0"
package "postgresql-contrib-9.0"

apt_repository "ubuntugis-ppa" do
  uri "http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu"
  key "314DF160"
  keyserver "keyserver.ubuntu.com"

  distribution "lucid"
  components   %w( main )

  action :add
end

package "proj"
package "libgeos-dev"
package "libgdal1-dev"

version = node[:postgis][:version]
path = "/usr/src/postgis-#{version}"

remote_file "#{path}.tar.gz" do
  source "http://postgis.refractions.net/download/postgis-#{version}.tar.gz"
  checksum node[:postgis][:checksum]
end

execute "untar postgis" do
  command "tar xzf postgis-#{version}.tar.gz"
  cwd "/usr/src"
  creates "#{path}/README.postgis"
end

execute "configure postgis" do
  command "./configure --prefix=/usr"
  cwd path
  creates "#{path}/config.status"
end

execute "build postgis" do
  command "make"
  cwd path
  creates "#{path}/postgis/postgis-1.5.so"
end

execute "install postgis" do
  command "make install"
  cwd path
  creates "/usr/lib/postgresql/9.0/lib/postgis-1.5.so"
end

# should you want to build and install a debian package
bash "build and install postgis-#{version}_amd64.deb" do
  cwd path
  code <<-EOH
  mkdir -p /tmp/installdir
  make install DESTDIR=/tmp/installdir
  gem install fpm --no-ri --no-rdoc
  cd /tmp/installdir
  fpm -s dir -t deb --name postgis --version #{version} \
    -C /tmp/installdir --package postgis-VERSION_ARCH.deb \
    usr/lib usr/share
  dpkg -i /tmp/installdir/postgis-#{version}_amd64.deb
  EOH
  creates "/usr/lib/postgresql/9.0/lib/postgis-1.5.so"
end
