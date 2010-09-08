#
# Cookbook Name:: accounts
# Recipe:: skel
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

# hide the annoying first-time ubuntu disclaimer
directory "/etc/skel/.cache"
file "/etc/skel/.cache/motd.legal-displayed"

# replace the bashrc with a slightly tweaked version
cookbook_file("/etc/skel/.bashrc") { source 'bashrc' ; mode 0644 }
