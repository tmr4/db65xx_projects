#include <conio.h>

unsigned char* putc = (unsigned char*) 0xf001;
unsigned char* getc = (unsigned char*) 0xf004;

void main (void)
{
        cprintf ("%s\r\n", "Hello world!");
}
