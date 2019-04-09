#include "init.h"
#include "process.h"
#include "interrupt.h"
#include "floppy.h"
#include "print_string.h"

extern TSS *tss;
extern UserRegisters uRegisters[NUM_MAX_TASK];
extern int CurrentTask;
void printk(int x, int y, char *str);
volatile void print_hex(int x, int y, int num);
void interrupt_A();
void LoadUserPrograms();
typedef struct _IDTR
{
    unsigned int limit;
    unsigned int link;
} IDTR;

IDTR temp;
void start_kernel()
{
    char *kernel_msg = ".Kernel is running";
    unsigned int *FirstTaskURegisters = (unsigned int *)&(uRegisters[0]);
    init_task();
    
    temp.limit = (unsigned short)0xffffffff;
    temp.link = 0xffffffff;
    print_hex(0, 11, (int)temp.limit);
    print_hex(0, 12, temp.link);
    
    SetInterrupts();

    __asm__ __volatile__("sidt %0":"=m"(temp) :);
    print_hex(0, 13, temp.limit);
    print_hex(0, 14, temp.link);

// int  v = 1;
//     while (v) {
//         v = 0;
//         v = 1;
//         printk(0, 0, kernel_msg);
//         kernel_msg[0]++;
//     }
    LoadUserPrograms();

    __asm__ __volatile__(
        "cli              \n\t"
        "mov $0x20, %%ax  \n\t"
        "ltr %%ax         \n\t"
        "mov %%esp, %0    \n\t"
        "mov %1, %%ebp    \n\t"
        "popal            \n\t"
        "pop %%ds         \n\t"
        "pop %%es         \n\t"
        "pop %%fs         \n\t"
        "pop %%gs         \n\t"
        "sti              \n\t"
        "iret             \n\t"
        : "=m"(tss->esp0)
        : "m"(FirstTaskURegisters));

    while (1)
        ;
}

void LoadUserPrograms()
{
    ReadSector(0, 0, 15, (unsigned char *)0x10000, (unsigned char *)0x80000000);
    ReadSector(0, 0, 16, (unsigned char *)0x10000, (unsigned char *)0x80000200);
    ReadSector(0, 0, 17, (unsigned char *)0x10000, (unsigned char *)0x80001000);
    ReadSector(0, 0, 18, (unsigned char *)0x10000, (unsigned char *)0x80001200);
    ReadSector(1, 0, 1, (unsigned char *)0x10000, (unsigned char *)0x80002000);
    ReadSector(1, 0, 2, (unsigned char *)0x10000, (unsigned char *)0x80002200);
    ReadSector(1, 0, 3, (unsigned char *)0x10000, (unsigned char *)0x80003000);
    ReadSector(1, 0, 4, (unsigned char *)0x10000, (unsigned char *)0x80003200);
}

void printk(int x, int y, char *str)
{
    if (x >= 80 || y >= 25)
    {
        return;
    }

    unsigned char *p = (unsigned char *)0xB8000 + (x*2) + 80 * y * 2;

    while (*str != 0)
    {
        *p = *str;
        p++;
        *p = 0x67;
        p++;
        str++;
    }
}

volatile void print_hex(int x, int y, int num)
{
    unsigned char vc[9];
    int count;
    unsigned char temp;
    count = 0;
    while (count < 9)
    {
        temp = (char)(num >> (4 * count));
        temp &= 0x0f;
        temp += 0x30;
        if (temp >= ':')
        {
            temp += 7;
        }
        vc[7 - count] = temp;
        count++;
    }
    vc[8] = 0;
    printk(x, y, vc);
}
