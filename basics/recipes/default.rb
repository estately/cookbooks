#
# Cookbook Name:: basics
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

packages = %w[
  ack-grep bridge-utils curl debconf-utils dstat emacs23-nox git-core
  htop man-db perl-doc s3cmd screen ssh strace sysstat tmux traceroute
  vim zsh
]

packages.each do |p|
  package(p) { action :upgrade }
end

gem_package "rake"

# fix ubuntu's broken naming of ack
link "/usr/bin/ack" do
  to "/usr/bin/ack-grep"
end
