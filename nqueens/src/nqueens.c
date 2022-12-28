// modified from: https://rosettacode.org/wiki/N-queens_problem#C
// for various solutions see: https://math.stackexchange.com/questions/1872444/how-many-solutions-are-there-to-an-n-by-n-queens-problem

#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define MAXN 31

const unsigned char *putc = (unsigned char *)0xf001;
const unsigned char *getc = (unsigned char *)0xf004;

// buffer for user input
char buffer[40];

int __cdecl__ nqueens(int n)
{
    int q0, q1;
    int *cols, *diagl, *diagr, *posibs; // backtracking 'stack'
    int posib;
    int num = 0;

    cols = (int *)malloc(MAXN * sizeof(int));
    diagl = (int *)malloc(MAXN * sizeof(int));
    diagr = (int *)malloc(MAXN * sizeof(int));
    posibs = (int *)malloc(MAXN * sizeof(int));

    // The top level is two fors, to save one bit of symmetry in the enumeration
    // by forcing second queen to be AFTER the first queen.
    for (q0 = 0; q0 < n - 2; q0++) {
        for (q1 = q0 + 2; q1 < n; q1++) {
            int bit0 = 1 << q0;
            int bit1 = 1 << q1;
            int d = 0;                         // d is our depth in the backtrack stack
            cols[0] = bit0 | bit1 | (-1 << n); // The -1 here is used to fill all 'coloumn' bits after n ...
            diagl[0] = (bit0 << 1 | bit1) << 1;
            diagr[0] = (bit0 >> 1 | bit1) >> 1;

            //  The variable posib contains the bitmask of possibilities we still have to try in a given row ...
            posib = ~(cols[0] | diagl[0] | diagr[0]);

            while (d >= 0) {
                while (posib) {
                    int bit = posib & -posib; // The standard trick for getting the rightmost bit in the mask
                    int ncols = cols[d] | bit;
                    int ndiagl = (diagl[d] | bit) << 1;
                    int ndiagr = (diagr[d] | bit) >> 1;
                    int nposib = ~(ncols | ndiagl | ndiagr);
                    posib ^= bit; // Eliminate the tried possibility.

                    // The following is the main additional trick here, as recognizing solution
                    // can not be done using stack level (d), since we save the depth+backtrack
                    // time at the end of the enumeration loop. However by noticing all coloumns
                    // are filled (comparison to -1) we know a solution was reached ...
                    // Notice also that avoiding an if on the ncols==-1 comparison is more efficient!
                    num += ncols == -1;

                    if (nposib) {
                        if (posib) {
                            // This if saves stack depth + backtrack operations when we passed the
                            // last possibility in a row.
                            posibs[d++] = posib; // Go lower in stack ..
                        }
                        cols[d] = ncols;
                        diagl[d] = ndiagl;
                        diagr[d] = ndiagr;
                        posib = nposib;
                    }
                }
                posib = posibs[--d]; // backtrack ...
            }
        }
    }
    return num * 2;
}

int __cdecl__ main(void)
{
    int n;

    printf("Enter the number of queens to use (between 2 and 31):\n");
    while (1) {
        fgets(buffer, sizeof(buffer) - 1, stdin); /* Get keyboard input */
        buffer[strlen(buffer) - 1] = '\0';        /* Remove trailing newline */
        if (buffer[0] == 'q') {
            break;
        } else {
            n = atoi(buffer);
            if (n < 1 || n > MAXN) {
                printf("n must be between 2 and 31!\n");
            } else {
                printf("Number of solution for %d is %d\n", n, nqueens(n));
                printf("Enter the number of queens or q to quit:\n");
            }
        }
    }
    return 0;
}
