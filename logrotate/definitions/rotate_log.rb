#
# Cookbook Name:: logrotate
# Definition:: rotate_log
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

DEFAULTS = {
  :compress  => true,
  :frequency => :daily,
  :datestamp => true,
  :keep      => 3650
}

define :rotate_log, DEFAULTS do

  # cover the case where params[:name] is just a file
  filename = params[:name].gsub( /[^a-z]/i, '_' )

  if params[:files].nil?
    params[:files] = params[:name]
  end

  # wrap all of the filenames in quotes, combine into single string
  params[:files] = params[:files].
    map {|f| "\"#{f}\"" }.
    join(' ')

  template "/etc/logrotate.d/#{filename}" do
    cookbook "logrotate"
    source "rotate_log.erb"

    owner "root"
    group "root"
    mode  0644

    variables params
  end
end
