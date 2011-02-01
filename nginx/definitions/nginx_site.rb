#
# Cookbook Name:: nginx
# Definition:: nginx_site
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

define :nginx_site, :action => :enable do

  template "/etc/nginx/sites-available/#{params[:name]}" do
    if params[:source]
      source params[:source]
    else
      source "nginx.#{params[:name]}.erb"
    end

    owner "root"
    group "root"
    mode  0644

    # pass through any variables given in the recipe
    variables params[:variables]

    notifies :restart, resources( :service => "nginx" )

    # we only want to try to render the template if we're enabling the
    # site, otherwise we can't disable sites we didn't create
    only_if { params[:action] == :enable }
  end

  link "/etc/nginx/sites-enabled/#{params[:name]}" do
    action :delete if params[:action] == :disable

    owner "root"
    group "root"

    to "/etc/nginx/sites-available/#{params[:name]}"

    notifies :restart, resources( :service => "nginx" )
  end

end
