#
# Cookbook Name:: postgresql
# Recipe:: ppa
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

apt_repository "pitti-ppa" do
  uri "http://ppa.launchpad.net/pitti/postgresql/ubuntu"
  key "8683D8A2"
  keyserver "keyserver.ubuntu.com"

  distribution "lucid"
  components   %w( main )

  action :add
end
