#
# CampfireHandler -- a simple Campfire handler for Chef
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

require 'rubygems'

require 'chef'
require 'chef/handler'

require 'sparks'

class CampfireHandler < Chef::Handler

  def initialize( opts = {} )
    @campfire = Sparks::Campfire.new( opts[:subdomain], opts[:apikey] )
    @room     = @campfire.room_named( opts[:room] )
  end

  def report
    @room.say "%s - %s" % [ node.hostname, run_status.formatted_exception ]
    @room.paste backtrace.join("\n")
  end

end
