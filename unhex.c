#include <stdio.h>

char digits[] = "0123456789abcdef";

void unhex(int val) {
    char buf[9];
    int i;
    for(i = 0; i < 8; i++) {
        //circular rotate left that mips has
        val = (val << 4) | (val >> (sizeof(int) * 8 - 4));
        buf[i] = digits[val & 0xf];
    }
    buf[8] = 0;
    printf("%s\n", buf);
}

int main() {
    unhex(0);
    unhex(-1);
    unhex(65535); 
    unhex(65536);
}
