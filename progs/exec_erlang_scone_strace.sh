SCONE_HEAP=2G SCONE_FORK=1 strace -s 120 -f -i -v -e 'trace=!nanosleep,futex,mmap,getpid,tgkill,brk,clock_gettime,arch_prctl,munmap,readlink,fstat,rt_sigaction,rt_sigprocmask,gettid,getpid,set_robust_list,sched_get_priority_min,ioctl' -o ./helloworld_SCONE.`date '+%Y%m%d%H%M%S'`.log erl +S 1:1 +A 1 -noshell -s helloworld start

