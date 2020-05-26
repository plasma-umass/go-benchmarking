#include <uthread.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define NUM_THREADS 16

uint64_t TERMS_PER_YIELD_LOG2;

typedef struct {
    uint64_t from;
    uint64_t to;
    double result;
    uthread_t tid;
} TermsArg;

double term(double kf, uint64_t ki) {
    int64_t sign = 2 * -((int64_t)ki % 2 ) + 1;
    double res = 4 * sign / (2*kf + 1);;

    if((ki % TERMS_PER_YIELD_LOG2) == 0) {
        uthread_yield();
    }

    return res;
}

void *terms(void *arg_tmp) {
    TermsArg *arg = (TermsArg *)arg_tmp;
    double f = 0;
    uint64_t from = arg->from;
    uint64_t to = arg->to;

    for(uint64_t k = from; k <= to; k++) {
        f += term(k, k);
    }

    arg->result = f;

    return NULL;
}


uint64_t exp2_int(uint64_t x) {
    uint64_t y = 1;
    for(uint64_t i = 0; i < x; i++) {
        y *= 2;
    }
    return y;
}


int main(int argc, char **argv) {
    uthread_init();

    if(argc != 3) {
        printf("Expected 2 args: log2(# terms) log2(# terms/yield)\n");
        return 1;
    }

    uint64_t NUM_TERMS = exp2_int(atoi(argv[1]));
    TERMS_PER_YIELD_LOG2 = exp2_int(atoi(argv[2]));
    

    TermsArg threads[NUM_THREADS];
    uint64_t termsPerThread = NUM_TERMS / NUM_THREADS;


    for(uint64_t thread = 0; thread < NUM_THREADS; thread++) {
        threads[thread].from = thread * termsPerThread;
        threads[thread].to = termsPerThread + thread*termsPerThread - 1;
        uthread_create(&threads[thread].tid, terms, &threads[thread]);
    }

    double pi = 0;
    for(uint64_t thread = 0; thread < NUM_THREADS; thread++) {
        uthread_join(threads[thread].tid, NULL);
        // printf("Done with tid = %d\n", threads[thread].tid);
        pi += threads[thread].result;
    }

    printf("%f\n", pi);
}