#include <stdio.h>
#include <stdlib.h>
#include <curand.h>
#include <curand_kernel.h>
#include "utils.h"

#define N_THREADS 1
#define N_BLOCKS 1

/*** GPU functions ***/
__global__ void init_rand_kernel(curandState *state) {
 int idx = blockIdx.x * blockDim.x + threadIdx.x;
 curand_init(0, idx, 0, &state[idx]);        
}
__global__ void random_walk_kernel(float *map, int rows, int cols, int* bx, int* by,
                                   int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  printf("%d\n", tid);
  //TODO: implement random walk!
}

__global__ void local_max_kernel(float *map, int rows, int cols, int* bx, int* by,
                                 int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  //TODO: implement local max!
}

__global__ void local_max_restart_kernel(float *map, int rows, int cols, int* bx,
                                         int* by, int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;
  //TODO: implement local max with restarts!
}

/*** CPU functions ***/
curandState* init_rand() {
  curandState *d_state;
  cudaMalloc(&d_state, N_BLOCKS * N_THREADS * sizeof(curandState));
  init_rand_kernel<<<N_BLOCKS, N_THREADS>>>(d_state);
  return d_state;
}


float random_walk(float* map, int rows, int cols, int steps) {
  curandState* d_state = init_rand();
  int *bx, *by;
  int *d_bx, *d_by;
  float* d_map;

  // Before kernel call:
  // Need to allocate memory for above variables and copy data to GPU

  /*
  float max = 0;
  float min = 0;
  for(int i = 0; i < rows * cols; i++) {
      if (map[i] > max) {
        max = map[i];
        printf("%f\n", max);
      }
      if (map[i] < min) {
        min = map[i];
        printf("%f\n", min);
      }
      if( i % 2048 == 0) {
        printf("%d\n", i);
      }
      
  }
  */

  bx = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));
  by = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));

  cudaMalloc(&d_bx, N_BLOCKS * N_THREADS * sizeof(float));
  cudaMalloc(&d_by, N_BLOCKS * N_THREADS * sizeof(float));

  

  cudaMalloc(&d_map, rows * cols * sizeof(float));
  cudaMemcpy(d_map, map, rows * cols * sizeof(float), cudaMemcpyHostToDevice);

  random_walk_kernel<<<N_BLOCKS, N_THREADS>>>(d_map, rows, cols, d_bx, d_by, steps, d_state);

  cudaMemcpy(map, d_map, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);

  cudaMemcpy(bx, d_bx, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(by, d_by, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);

  // After kernel call:
  // Need to copy data back to CPU and find max value

  

  float max_val = 0;

  // Finally: free used GPU and CPU memory
  //cudaFree(d_state);
  //cudaFree(d_map);
  //free(map);
  return max_val;
}

// Work on these after finishing random walk
float local_max(float* map, int rows, int cols, int steps);
float local_max_restart(float* map, int rows, int cols, int steps);


int main(int argc, char** argv) {
  if (argc != 2) {
    printf("Usage: %s <map_file> \n", argv[0]);
    return 1;
  }

  float *map;
  int rows, cols;
  read_bin(argv[1], &map, &rows, &cols);
  printf("%d %d\n", rows, cols);


  // As a starting point, try to get it working with a single steps value
  int steps = 10;
  float max_val = random_walk(map, rows, cols, steps);
  
  printf("%d %d\n", rows, cols);
  printf("Random walk max value: %f\n", max_val);

  return 0;
}