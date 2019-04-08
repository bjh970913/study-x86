#include <stdio.h>

void print_it();

int main(){
    print_it();
}

void print_it(){
    char *lucky = "Luck number is %d";
    printf(lucky, 7);
}