// modified from: https://rosettacode.org/wiki/Sieve_of_Eratosthenes#C

/************************************************************
We first fill ones into an array and assume all numbers are prime.
Then, in a loop, fill zeroes into those places where i * j is less
than or equal to n (number of primes requested), which means they
have multiples!

To print this back, we look for ones in the array and only print
those spots.
*************************************************************/

#include <stdio.h>
#include <stdlib.h>

//#pragma static-locals(on);

const unsigned char* putc = (unsigned char*) 0xf001;
const unsigned char* getc = (unsigned char*) 0xf004;

void sieve(int *, int);

int main()
{
    int *array, n=10;
    array =(int *)malloc((n + 1) * sizeof(int));

    sieve(array,n);
    return 0;
}

void sieve(int *a, int n)
{
    int i=0, j=0;

    for(i=1; i<=n; i++) {
        a[i] = 1;
    }

    for(i=2; i<=n; i++) {
        if(a[i] == 1) {
            for(j=i; (i*j)<=n; j++) {
                a[(i*j)] = 0;
            }
        }
    }

    printf("\nPrimes numbers from 1 to %d are : ", n);
    for(i=1; i<=n; i++) {
        if(a[i] == 1)
            printf("%d, ", i);
    }
    printf("\n");
}
