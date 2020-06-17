#include <stdio.h>
// #include <math.h>
#include <time.h>
#include <string.h>
#include <stdlib.h>

int32_t the_count1 = 0;
int32_t the_count2 = 0;
int32_t the_count3 = 0;

void __attribute__ ((noinline)) stuff() {
    the_count1 += 1;
    the_count2 += 2;
    the_count3 += 6;
}

double pi(int64_t numTerms) {
    double f = 0.0;
    // int32_t sign = 1;
    for(int64_t k = 1; k <= numTerms; k++) {
        f += 1.0 / (double)k;
        // sign *= -1;
        stuff();

        // sum
        // int64_t sign = 2 * -(k % 2) + 1;
        // f += ((double) (4 * sign)) / (2*((double)k) + 1);
    }

	return f;
}

int main(int argc, char **argv) {
    // int numTerms = atoi(argv[1]);
    uint64_t numTerms = strtoull(argv[1], NULL, 10);

    struct timespec tstart={0,0}, tend={0,0};
    clock_gettime(CLOCK_MONOTONIC, &tstart);
    
    printf("%f\n", pi(numTerms));
    printf("%d %d %d\n", the_count1, the_count2, the_count3);

    clock_gettime(CLOCK_MONOTONIC, &tend);
    double dt = ((double)tend.tv_sec + 1.0e-9*tend.tv_nsec) - ((double)tstart.tv_sec + 1.0e-9*tstart.tv_nsec);
    long long unsigned int dt_nanos = (long long unsigned int)(1000000000 * dt);
    fprintf(stderr, "%llu\n", dt_nanos);
}




