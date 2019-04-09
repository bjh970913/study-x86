#include "init.h"
#include "process.h"

TSS *tss;
UserRegisters uRegisters[NUM_MAX_TASK];
int CurrentTask;

void init_task()
{
    int i, eip;

    unsigned int *tss_where = (unsigned int *)TSS_WHERE;
    tss = (TSS *)*tss_where;

    eip = 0x80000000;

    for (i = 0; i < 5; i++)
    {
        uRegisters[i].eip = eip;
        uRegisters[i].cs = UserCodeSelector;
        uRegisters[i].eflags = 0x200;
        uRegisters[i].esp = eip + 0xfff;
        uRegisters[i].ss = UserDataSelector;

        uRegisters[i].ds = UserDataSelector;
        uRegisters[i].es = UserDataSelector;
        uRegisters[i].fs = UserDataSelector;
        uRegisters[i].gs = UserDataSelector;

        eip += 0x1000;
    }

    CurrentTask = 0;
}

void schedule()
{
    char *msg = ". scheduler running";
    printk(0, 1, msg);
    msg[0]++;
    print_hex(20, 1, CurrentTask);
    static unsigned int *ebp_A;
    static int NextTask;
    static unsigned int *CurrentTaskURegisters;
    static unsigned int *NextTaskURegisters;
    static unsigned int *RegistersInStack;

    static int i;

    __asm__ __volatile(
        "mov %%ebp, %0"
        : "=m"(ebp_A)
        :);
    print_hex(31, 1, (ebp_A[15] & 0x00000003));
    if ((ebp_A[15] & 0x00000003) == 0)
    {
        return;
    }

    NextTask = CurrentTask + 1;
    if (NextTask == NUM_MAX_TASK)
    {
        NextTask = 0;
    }

    RegistersInStack = &ebp_A[2];

    CurrentTaskURegisters = (unsigned int *)&(uRegisters[CurrentTask]);

    CurrentTask = NextTask;

    for (i = 0; i < 17; i++)
    {
        CurrentTaskURegisters[i] = RegistersInStack[i];
    }

    NextTaskURegisters = (unsigned int *)&(uRegisters[NextTask]);

    __asm__ __volatile__(
        "mov %%ebp, %%esp  \n\t"
        "pop %%ebp         \n\t"
        "add $4, %%esp     \n\t"
        "add $68, %%esp    \n\t"
        "mov %%esp, %0     \n\t"
        "mov %1, %%esp     \n\t"
        "popal             \n\t"
        "pop %%ds          \n\t"
        "pop %%es          \n\t"
        "pop %%fs          \n\t"
        "pop %%gs          \n\t"
        "iret              \n\t"
        : "=m"(tss->esp0)
        : "m"(NextTaskURegisters));
}
