#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
#include "pstat.h"
#include "stat.h"

struct syscall_stat syscall_stats[NSYSCALLS];
struct spinlock history_lock;
extern struct proc proc[NPROC];
uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0; // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if (n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (killed(myproc()))
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_history(void)
{
  // printf("1 Inside syshistory\n");
  acquire(&history_lock);

  // printf("2 Inside syshistory\n");
  uint64 user_addr;
  int id;

  argint(0, &id);
  argaddr(1, &user_addr);
  id--;
  // printf("Name = %s ", syscall_stats[id].syscall_name);
  // printf("Count = %d ", syscall_stats[id].count);
  // printf("Time = %d\n", syscall_stats[id].accum_time);

  if (copyout(myproc()->pagetable, user_addr, (char *)&syscall_stats[id], sizeof(syscall_stats[id])) < 0)
  {
    release(&history_lock);
    return -1;
  }
  // printf("1 Outside syshistory\n");
  release(&history_lock);
  // printf("2 Outside syshistory\n");
  return 0;
}

uint64 sys_settickets(void)
{
  // printf("inside to set tickets\n");
  int tickets;
  (argint(0, &tickets));

  struct proc *p = myproc();

  if (tickets < 1)
  {
    return -1;
  }
  // p->inQ = 1; // need to check NOWWWW
  p->tickets_original = tickets;
  p->tickets_current = tickets;

  // if (PRINT_SCHEDULING)
  // {
  //   printf("Setting tickets number=%d\n", tickets);
  //   printf("sys_settickets: PID %d, tickets_original=%d, tickets_current=%d, inQ=%d\n",
  //          p->pid, p->tickets_original, p->tickets_current, p->inQ);
  // }
  return 0;
}
//  dummyproc 12 &; dummyproc 99 &; dummyproc 150 &
//   testprocinfo &; testprocinfo &; testprocinfo
uint64 sys_getpinfo(void)
{
  // printf("inside getpinfo\n");
  struct pstat my_pstat;

  // printf("PID | STATE | inQ | Original Tickets | Current Tickets | Time Slices\n");

  for (int i = 0; i < NPROC; i++)
  {
    struct proc *p = &proc[i];
    acquire(&p->lock);
    my_pstat.inuse[i] = (p->state != UNUSED);
    my_pstat.pid[i] = p->pid;
    my_pstat.inQ[i] = p->inQ;
    my_pstat.tickets_original[i] = p->tickets_original;
    my_pstat.tickets_current[i] = p->tickets_current;
    my_pstat.time_slices[i] = p->total_time;

    // if (PRINT_SCHEDULING)
    // {

    //   if (p->tickets_original != 0)
    //   {
    //     printf("%d  |   %d   |  %d   | %d           |        %d         |       %d     \n",
    //            p->pid,
    //            p->state,
    //            p->inQ,
    //            p->tickets_original,
    //            p->tickets_current,
    //            p->total_time);
    //   }
    // }
    release(&p->lock);
  }

  uint64 user_addr;
  argaddr(0, &user_addr);

  if (copyout(myproc()->pagetable, user_addr, (char *)&my_pstat, sizeof(my_pstat)) < 0)
  {
    return -1;
  }

  return 0;
}