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

package( "ack-grep" ) { action :upgrade }
package( "curl"     ) { action :upgrade }
package( "dstat"    ) { action :upgrade }
package( "git-core" ) { action :upgrade }
package( "htop"     ) { action :upgrade }
package( "man-db"   ) { action :upgrade }
package( "perl-doc" ) { action :upgrade }
package( "screen"   ) { action :upgrade }
package( "ssh"      ) { action :upgrade }
package( "strace"   ) { action :upgrade }
package( "sysstat"  ) { action :upgrade }
package( "tmux"     ) { action :upgrade }
package( "vim"      ) { action :upgrade }
package( "zsh"      ) { action :upgrade }

# fix ubuntu's broken naming of ack
link "/usr/bin/ack" do
  to "/usr/bin/ack-grep"
end
