#
# Cookbook Name:: librets
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

# dependencies
package "libcurl4-openssl-dev"
package "libexpat1-dev"
package "libboost-dev"
package "libboost-filesystem-dev"
package "swig"

cookbook_file "/tmp/librets-1.5.1.tar.gz" do
	source "librets-1.5.1.tar.gz"
	mode "644"
	not_if "test -f /tmp/librets-1.5.1.tar.gz"
end

cookbook_file "/tmp/rubytracking.swg" do
	source "rubytracking.swg"
	mode "644"
	not_if "test -f /tmp/rubytracking.swg"
end

execute "Prepare Software" do
	command "cd /tmp; tar -xzvf librets-1.5.1.tar.gz; cd /tmp/librets-1.5.1; mkdir -p project/swig/lib/ruby;"
	not_if "test -d /tmp/librets-1.5.1"
end

execute "Copy rubytracking File" do
	command "cd /tmp/librets-1.5.1; mv /tmp/rubytracking.swg project/swig/lib/ruby/rubytracking.swg;"
	not_if "test -f /tmp/librets-1.5.1/project/swig/lib/ruby/rubytracking.swg"
end

execute "Make Software" do
	command "cd /tmp/librets-1.5.1; ./configure --disable-debug --disable-dotnet --disable-java --disable-perl --disable-php --disable-python --disable-sql-compiler --enable-shared-dependencies; make;"
	not_if "test -f /usr/local/lib/site_ruby/1.8/x86_64-linux/librets_native.so"
end

execute "Make more Software" do
	command "cd /tmp/librets-1.5.1; rm build/swig/ruby/librets_wrap.*; make; sudo make install;"
	not_if "test -f /usr/local/lib/site_ruby/1.8/x86_64-linux/librets_native.so"
end
