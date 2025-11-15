#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "defs.h"
#include "stat.h"
#include "pstat.h"

volatile static int started = 0;

extern struct syscall_stat syscall_stats[NSYSCALLS]; // must include the header file. naile datatype chinbena
extern struct spinlock history_lock;
extern struct spinlock proc_table_lock;
void init_syscall_stats()
{
  initlock(&history_lock, "history_lock");
  initlock(&proc_table_lock, "proc_table");

  char *names[NSYSCALLS] = {
      "fork",
      "exit",
      "wait",
      "pipe",
      "read",
      "kill",
      "exec",
      "fstat",
      "chdir",
      "dup",
      "getpid",
      "sbrk",
      "sleep",
      "uptime",
      "open",
      "write",
      "mknod",
      "unlink",
      "link",
      "mkdir",
      "close",
      "history",
      "settickets",
      "getpinfo",

  };

  for (int i = 0; i < NSYSCALLS; i++)
  {
    safestrcpy(syscall_stats[i].syscall_name, names[i], sizeof(syscall_stats[i].syscall_name));
    syscall_stats[i].count = 0;
    syscall_stats[i].accum_time = 0;
  }
}

// start() jumps here in supervisor mode on all CPUs.
void main()
{
  if (cpuid() == 0)
  {
    consoleinit();
    printfinit();
    printf("\n");
    printf("xv6 kernel is booting\n");
    printf("\n");
    kinit();            // physical page allocator
    kvminit();          // create kernel page table
    kvminithart();      // turn on paging
    procinit();         // process table
    trapinit();         // trap vectors
    trapinithart();     // install kernel trap vector
    plicinit();         // set up interrupt controller
    plicinithart();     // ask PLIC for device interrupts
    binit();            // buffer cache
    iinit();            // inode table
    fileinit();         // file table
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __sync_synchronize();
    started = 1;
  }
  else
  {
    while (started == 0)
      ;
    __sync_synchronize();
    printf("hart %d starting\n", cpuid());
    kvminithart();  // turn on paging
    trapinithart(); // install kernel trap vector
    plicinithart(); // ask PLIC for device interrupts
  }
  // srand(12345);
  init_syscall_stats();
  scheduler();
}
