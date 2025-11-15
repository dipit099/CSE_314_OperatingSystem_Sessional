#include "kernel/types.h"
#include "kernel/param.h"
#include "user/user.h"
#include "kernel/stat.h"

int main(int argc, char *argv[])
{
    struct syscall_stat current_call;

    if (argc == 2)
    {
        int num = atoi(argv[1]);
        printf("%d: ", num);
        history(num, &current_call);
        printf("syscall: %s, ", current_call.syscall_name);
        printf("#: %d, ", current_call.count);
        printf("time: %d\n", current_call.accum_time);
    }
    else if (argc == 1)
    {
        // printf("History for all syscalls\n");

        for (int i = 1; i <= NSYSCALLS; i++)
        {
            history(i, &current_call);
            printf("syscall: %s, ", current_call.syscall_name);
            printf("#: %d, ", current_call.count);
            printf("time: %d\n", current_call.accum_time);
        }
    }
    else
    {
        printf("Nothing\n");
    }
}