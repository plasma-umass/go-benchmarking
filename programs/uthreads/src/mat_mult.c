#include <uthread.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS 16
#define NUM_ROWS 64

int ROWS_PER_YIELD_LOG2;

typedef struct {
    double *start1;
    double *start2;
    int num_thread_rows;
    int num_rows;
    int num_cols;
    double *result;
    uthread_t tid;
} TermsArg;


int terms(void *arg_tmp) {
    return 0;   
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

    if(argc != 2) {
        printf("Expected 2 args: log2(# cols)\n");
        return 1;
    }

    uint64_t NUM_COLS = exp2_int(atoi(argv[1]));
    

    TermsArg threads[NUM_THREADS];
    int rowsPerThread = NUM_ROWS / NUM_THREADS;

    double *x = malloc(sizeof(double) * NUM_ROWS * NUM_COLS);
    double *y = malloc(sizeof(double) * NUM_COLS * NUM_ROWS);
    double *result = malloc(sizeof(double) * NUM_ROWS * NUM_ROWS);

    for (int r=0; r<NUM_ROWS; r=r+1){
        
        for (int c=0; c<NUM_ROWS; c=c+1){
            result[r*NUM_ROWS + c]=0.0;
            for (int k=0; k<NUM_COLS; k=k+1){
                result[r*NUM_ROWS + c] = (result[r*NUM_ROWS + c]) + ((x[r*NUM_COLS + k])*(y[k*NUM_ROWS + c]));
            }
        }
    }

    double sum = 0.0;
    for(int i = 0; i < NUM_ROWS * NUM_ROWS; i++) {
        sum += result[i];
    }
    printf("%f\n", sum);
}