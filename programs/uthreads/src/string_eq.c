#include <uthread.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS 16

int CHARS_PER_YIELD_LOG2;

typedef struct {
    char *start1;
    char *start2;
    int len;
    char result; // a bool
    uthread_t tid;
} TermsArg;


void *terms(void *arg_tmp) {
    TermsArg *arg = (TermsArg *)arg_tmp;
    char eq = 0;

    for(int k = 0; k < arg->len; k++) {
        if(arg->start1[k] != arg->start2[k]) {
            arg->result = 0;
            return 0;
        }

        if((k % CHARS_PER_YIELD_LOG2) == 0) {
            uthread_yield();
        }
    }

    arg->result = 1;
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
        printf("Expected 2 args: log2(# chars) log2(# chars/yield)\n");
        return 1;
    }

    uint64_t NUM_CHARS = exp2_int(atoi(argv[1]));
    CHARS_PER_YIELD_LOG2 = exp2_int(atoi(argv[2]));
    

    TermsArg threads[NUM_THREADS];
    int charsPerThread = NUM_CHARS / NUM_THREADS;

    char *s1 = malloc(sizeof(char) * NUM_CHARS);
    char *s2 = malloc(sizeof(char) * NUM_CHARS);
    memcpy(s1, s2, sizeof(char)*NUM_CHARS);
    
    for(int thread = 0; thread < NUM_THREADS; thread++) {
        threads[thread].start1 = s1 + thread * charsPerThread;
        threads[thread].start2 = s2 + thread * charsPerThread;
        threads[thread].len = charsPerThread;
        uthread_create(&threads[thread].tid, terms, &threads[thread]);
    }

    char eq = 1;
    for(int thread = 0; thread < NUM_THREADS; thread++) {
        uthread_join(threads[thread].tid, NULL);
        // printf("Done with tid = %d\n", threads[thread].tid);
        eq = eq && threads[thread].result;
    }

    printf("%d\n", (int)eq);
}