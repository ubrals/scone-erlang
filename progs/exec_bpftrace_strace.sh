sudo -E BPFTRACE_MAX_MAP_KEYS=5120000 -E SCONE_BPFTRACE=1 -E SCONE_MAP_LAYOUT=1 -E SCONE_MODE=sim /mnt/bpft/bpftrace_static --include /mnt/bpft/missing_types_mig.h union_cleaner_inner_cgroup_profiler.bt -o ./_bpft.union.`date '+%Y%m%d%H%M%S'`.log -c '/bin/sh -c ./exec_erlang_scone_strace.sh'

