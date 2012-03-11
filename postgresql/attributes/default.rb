#
# Cookbook Name:: postgresql
# Attributes:: default
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

default.postgresql.data_directory                 "/var/lib/postgresql/9.0/main"
default.postgresql.max_connections                100
default.postgresql.ssl                            false
default.postgresql.shared_buffers                 "24MB"
default.postgresql.work_mem                       "1MB"
default.postgresql.maintenance_work_mem           "16MB"
default.postgresql.wal_buffers                    "64kB"
default.postgresql.checkpoint_segments            3
default.postgresql.checkpoint_completion_target   0.5
default.postgresql.effective_cache_size           "128MB"
default.postgresql.log_min_duration_statement     "-1"
default.postgresql.log_duration                   "off"
default.postgresql.log_line_prefix                "%t "
default.postgresql.log_statement                  "none"
default.postgresql.autovacuum_vacuum_threshold    50
default.postgresql.autovacuum_vacuum_scale_factor 0.2

# these two settings are determing at postgresql compile-time, so they
# should only be set if your postgresql already has different values.
default.postgresql.block_size     8192
default.postgresql.wal_block_size 8192

# default shmmax setting... it's probably too low, which will cause your
# postgresql server to not start up. override this fo' sho'
total_memory          = node.memory.total.match( /^(\d+)/ )[1].to_i * 1_024
default.sysctl.shmmax = (total_memory * 0.02).to_i
