#include <stdio.h>

void print_it();

int main(){
    prt();
}

void print_it(){
    char *lucky = "Luck number is %d\n";
    printf(lucky, 7);
}
