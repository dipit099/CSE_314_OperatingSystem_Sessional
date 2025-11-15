#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/pstat.h"

int main(int argc, char *argv[])
{
    struct pstat pstat;
    getpinfo(&pstat);
    printf("################################################################################\n");
    printf("PID  |  In Use  |  InQ  |  Original Tickets  |  Current Tickets  |  Time Slices\n");
    for (int i = 0; i < NPROC; i++)
    {
        if (pstat.pid[i] != 0)
        {
            printf(" %d\t  %d\t    %d\t\t   %d\t\t\t%d\t\t %d\n", pstat.pid[i],
                   pstat.inuse[i],
                   pstat.inQ[i],
                   pstat.tickets_original[i],
                   pstat.tickets_current[i],
                   pstat.time_slices[i]);
        }
    }
    printf("################################################################################\n\n");
    return 0;
}