sudo /mnt/bpft/bpftrace_static --include /mnt/bpft/missing_types_mig.h union_cleaner_inner_cgroup.bt -o ./_bpft.union.`date '+%Y%m%d%H%M%S'`.log -c '/bin/sh -c ./exec_erlang_scone_strace.sh'

