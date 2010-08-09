default.postgresql.max_connections              100
default.postgresql.shared_buffers               "24MB"
default.postgresql.max_prepared_transactions    0
default.postgresql.work_mem                     "1MB"
default.postgresql.maintenance_work_mem         "16MB"
default.postgresql.max_stack_depth              "2MB"
default.postgresql.wal_buffers                  "64kB"
default.postgresql.checkpoint_segments          3
default.postgresql.checkpoint_completion_target 0.5
default.postgresql.effective_cache_size         "128MB"
default.postgresql.default_statistics_target    100
default.postgresql.autovacuum_max_workers       3
default.postgresql.max_locks_per_transaction    64

# these two settings are determing at postgresql compile-time, so they
# should only be set if your postgresql already has different values.
default.postgresql.block_size     8192
default.postgresql.wal_block_size 8192

# default shmmax setting... it's probably too low, which will cause your
# postgresql server to not start up. override this fo' sho'
total_memory          = node.memory.total.match( /^(\d+)/ )[1].to_i * 1_024
default.sysctl.shmmax = (total_memory * 0.02).to_i
