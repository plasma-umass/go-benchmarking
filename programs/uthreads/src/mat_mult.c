#include <uthread.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_THREADS 16
#define NUM_ROWS 64

typedef struct {
    double *x;
    double *y;
    int start_row;
    int num_thread_rows;
    int num_rows;
    int num_cols;
    double *result;
    uthread_t tid;
} ThreadArg;


int thread(void *arg_tmp) {
    ThreadArg *arg = (ThreadArg *)arg_tmp;
    double *x = arg->x;
    double *y = arg->y;
    double *result = arg->result;


    for (int r=arg->start_row; r<arg->start_row + arg->num_thread_rows; r=r+1){
        for (int c=0; c<arg->num_rows; c=c+1){
            result[r*arg->num_rows + c]=0.0;
            for (int k=0; k<arg->num_cols; k=k+1){
                result[r*arg->num_rows + c] = (result[r*arg->num_rows + c]) + ((x[r*arg->num_cols + k])*(y[k*arg->num_rows + c]));
                uthread_yield();
            }
        }
    }

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

    if(argc < 2) {
        printf("Expected 2 args: log2(# cols)\n");
        return 1;
    }

    uint64_t NUM_COLS = exp2_int(atoi(argv[1]) / 2 - 2);
    

    ThreadArg threads[NUM_THREADS];
    int rowsPerThread = NUM_ROWS / NUM_THREADS;

    double *x = malloc(sizeof(double) * NUM_ROWS * NUM_COLS);
    double *y = malloc(sizeof(double) * NUM_COLS * NUM_ROWS);
    double *result = malloc(sizeof(double) * NUM_ROWS * NUM_ROWS);

    for(int t = 0; t < NUM_THREADS; t++) {
        threads[t].x = x;
        threads[t].y = y;
        threads[t].start_row = t*rowsPerThread;
        threads[t].num_thread_rows = rowsPerThread;
        threads[t].num_rows = NUM_ROWS;
        threads[t].num_cols = NUM_COLS;
        threads[t].result = result;
        threads[t].tid = uthread_create(thread, &threads[t]);
    }

    for (int t=0; t<NUM_THREADS; t=t+1){
        uthread_join(threads[t].tid, NULL);
    }

        // for (int c=0; c<NUM_ROWS; c=c+1){
        //     result[r*NUM_ROWS + c]=0.0;
        //     for (int k=0; k<NUM_COLS; k=k+1){
        //         result[r*NUM_ROWS + c] = (result[r*NUM_ROWS + c]) + ((x[r*NUM_COLS + k])*(y[k*NUM_ROWS + c]));
        //     }
        // }

    double sum = 0.0;
    for(int i = 0; i < NUM_ROWS * NUM_ROWS; i++) {
        sum += result[i];
    }
    printf("%f\n", sum);
}