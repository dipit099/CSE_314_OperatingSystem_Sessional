#include "kernel/types.h"
#include "user/user.h"
#include "kernel/stat.h"


int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: dummyproc <tickets>\n");
        exit(1);
    }

    int tickets = atoi(argv[1]);
    if (settickets(tickets) == -1)
    {
        printf("Settickets criteria not fulfilled\n");
        exit(1);
    }

    for (int i = 1; i <= 5; i++)
    {
        for (int j = 1; j <= 10000000; j++)
        {
            if (j % 10000000 == 0)
            {

                fork();
                sleep(100);
            }
        }
    }
}

/*
dummyproc 3 &
dummyproc 5 &
dummyproc 30 &
testprocinfo &
testprocinfo

*/