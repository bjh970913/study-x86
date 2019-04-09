#define IDT_BASE            0xC0002000
#define KERNEL_OFFSET       0xC0000000
#define SysCodeSelector     0x08

void print_stack();

extern void LoadIDT();
extern void EnablePIC();
extern void isr_ignore();
extern void isr_32_timer();
extern void isr_33_keyboard();
extern void isr_38_floppy();
extern void isr_128_soft_int();
extern void (*isr_00(void))();
extern void isr_01();
extern void isr_02();
extern void isr_03();
extern void isr_04();
extern void isr_05();
extern void isr_06();
extern void isr_07();
extern void isr_08();
extern void isr_09();
extern void isr_10();
extern void isr_11();
extern void isr_12();
extern void isr_13();
extern void isr_14();
extern void isr_15();
extern void isr_17();

void SetInterrupts();
void PutIDT(int num, void *handler, unsigned char access);
void TimerHandler();
void FloppyHandler();
void printk(int x, int y, char*str);
volatile void print_hex(int x, int y, int num);
void delay(int TenMillisecond);

typedef struct _IDT_Desc
{
    unsigned short handler_low;
    unsigned short cs;
    unsigned char no_use;
    unsigned char type;
    unsigned short handler_high;
} IDT_Desc;
