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

# share this proc across all the resources
not_if_proc = Proc.new { File.exists? "/usr/local/lib/site_ruby/1.8/x86_64-linux/librets_native.so" }

# copy up librets source and rubytracking patch
cookbook_file("/tmp/librets-1.5.1.tar.gz") { not_if not_if_proc }
cookbook_file("/tmp/rubytracking.swg")     { not_if not_if_proc }

bash "install librets" do
  user "root"
  cwd "/tmp"

  not_if not_if_proc

  code <<-EOF
    tar zxf librets-1.5.1.tar.gz
    cd librets-1.5.1

    mkdir -p project/swig/lib/ruby
    mv /tmp/rubytracking.swg project/swig/lib/ruby/rubytracking.swg

    ./configure --disable-debug    \
      --disable-dotnet             \
      --disable-java               \
      --disable-perl               \
      --disable-php                \
      --disable-python             \
      --disable-sql-compiler       \
      --enable-shared-dependencies

    make
    rm build/swig/ruby/librets_wrap.*
    make
    make install
  EOF

end
