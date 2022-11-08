#include <stdio.h>
#include <stdlib.h>
#include <curand.h>
#include <curand_kernel.h>
#include "utils.h"

#define N_THREADS 1024
#define N_BLOCKS 16

/*** GPU functions ***/
__global__ void init_rand_kernel(curandState *state) {
 int idx = blockIdx.x * blockDim.x + threadIdx.x;
 curand_init(0, idx, 0, &state[idx]);        
}
__global__ void random_walk_kernel(float *map, int rows, int cols, int* bx, int* by,
                                   int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;

  float start = curand_uniform(&state[tid]);
  int idx = start * rows * cols;
  int x = idx / cols; 
  int y = idx % cols;

  float max_height = map[idx];
  bx[tid] = x;
  by[tid] = y;

  for(int i = 0; i < steps; i++) {
    float randNum = curand_uniform(&state[tid]);
    int randIdx = int(4 * randNum); //make number from 0-3
  
    switch (randIdx) {
      case 0:
        if (y != 0) { //left
          y = y - 1;
        } else if (x != 0) { //if y = 0 than decrease x
          x = x - 1;
        }
        break;
      case 1:
        if (x != 0) {  //top
          x = x - 1;
        } else if (y != 0) { // if x= 0 than decrease y
            y = y - 1;
        }
        break;
      case 2:
        if (y != (cols - 1)) { //right
          y = y + 1;
        } else if (x != (rows - 1)) { //if y is in last column increase x
          x = x + 1;
        }
        break;
      case 3:
      if (x != (rows - 1)) { //bottom
        x = x + 1;
        break;
      } else if (y != (cols - 1)) { //if x is in last row increase y
            y = y + 1;
        break;
      }
    }
    idx = x * 6114 + y; //make single index
    float height = map[idx];
    if (height > max_height) {
      max_height = height;
      bx[tid] = x;
      by[tid] = y;
    }
  }
 
  //TODO: implement random walk!
}

__global__ void local_max_kernel(float *map, int rows, int cols, int* bx, int* by,
                                 int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;

  float start = curand_uniform(&state[tid]);
  int idx = start * rows * cols;
  int x = idx / cols;
  int y = idx % cols;

  float max_height = map[idx];
  bx[tid] = x;
  by[tid] = y;

  for(int i = 0; i < steps; i++) {

    float left, top, right, bottom; //initalize floats for the pixels to the left, right, etc of the current pixel

    if (y != 0) { //y = y - 1;
      int leftIdx = (x * cols) + y - 1;
      left = map[leftIdx];
    } else {
      left = -99;
    }

    if (x != 0) {   //x = x - 1;
      int topIdx = ((x - 1) * cols) + y;
      top = map[topIdx];
    } else {
      top = -99;
    }
       
     
    if (y != (cols -1)) {  //y = y + 1;
      int rightIdx = (x * cols) + y + 1;
      right = map[rightIdx];
      
    } else {
      right = -99;
    }
    
    if (x != (rows - 1)) {  //x = x + 1;
      int bottomIdx = ((x + 1) * cols) + y;
      bottom = map[bottomIdx];
    } else {
      bottom = -99;
    }

    if (left > top  && left > right && left > bottom) { //find highest of left, right etc
      y = y - 1;
    } else if (top > left && top > right && top > bottom) {
      x = x - 1;
    } else if (right > left && right > top && right > bottom) {
      y = y + 1;
    } else {
      x = x + 1;
    }

    int currMaxIdx = x * 6114 + y; 
    float currMax = map[currMaxIdx]; //map value at the best index
    
    if (currMax > max_height) {
      max_height = currMax;
      bx[tid] = x;
      by[tid] = y;
    }
  }
 
  //TODO: implement local max!
}

__global__ void local_max_restart_kernel(float *map, int rows, int cols, int* bx,
                                         int* by, int steps, curandState *state) {
  int tid = threadIdx.x + blockIdx.x * blockDim.x;

  float start = curand_uniform(&state[tid]);
  int idx = start * rows * cols;
  int x = idx / cols;
  int y = idx % cols;

  float max_height = map[idx];
  bx[tid] = x;
  by[tid] = y;
  
  int last_max = 0;
  for(int i = 0; i < steps; i++) {

    float left, top, right, bottom;

    
    if (y != 0) {
      int leftIdx = (x * cols) + y - 1;
      left = map[leftIdx];
      //y = y - 1;
    } else {
      left = -99;
    }

    if (x != 0) {
      int topIdx = ((x - 1) * cols) + y;
      top = map[topIdx];
      //x = x - 1;
    } else {
      top = -99;
    }
       
     
    if (y != (cols -1)) {
      int rightIdx = (x * cols) + y + 1;
      right = map[rightIdx];
      //y = y + 1;
      
    } else {
      right = -99;
    }
    
    if (x != (rows - 1)) {
      int bottomIdx = ((x + 1) * cols) + y;
      bottom = map[bottomIdx];
      //x = x + 1;
    } else {
      bottom = -99;
    }

    if (left > top  && left > right && left > bottom) {
      y = y - 1;
    } else if (top > left && top > right && top > bottom) {
      x = x - 1;
    } else if (right > left && right > top && right > bottom) {
      y = y + 1;
    } else {
      x = x + 1;
    }

    int currMaxIdx = x * 6114 + y;
    float currMax = map[currMaxIdx];
    last_max = last_max + 1;    //add a step since last max
    
    if (currMax > max_height) {
      last_max = 0;
      max_height = currMax;
      bx[tid] = x;
      by[tid] = y;
    }

    if (last_max > 4) { //get a new index
      float newStart = curand_uniform(&state[tid]);
      int newIdx = newStart * rows * cols;
      x = newIdx / cols;
      y = newIdx % cols;
    }

  }
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
  for(int i = 0; i < N_BLOCKS * N_THREADS; i++) {
    int x = bx[i];
    int y = by[i];
    int idx = x * 6114 + y;
    float height = map[idx];
    if (height > max_val) {
      max_val = height;
    }
  }

  // Finally: free used GPU and CPU memory
  cudaFree(d_state);
  cudaFree(d_map);
  cudaFree(d_bx);
  cudaFree(d_by);
  free(bx);
  free(by);
  return max_val;
}

// Work on these after finishing random walkif (y != 0)
float local_max(float* map, int rows, int cols, int steps){
  curandState* d_state = init_rand();
  int *bx, *by;
  int *d_bx, *d_by;
  float* d_map;

  // Before kernel call:
  // Need to allocate memory for above variables and copy data to GPU

  bx = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));
  by = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));
  cudaMalloc(&d_bx, N_BLOCKS * N_THREADS * sizeof(float));
  cudaMalloc(&d_by, N_BLOCKS * N_THREADS * sizeof(float));

  
  cudaMalloc(&d_map, rows * cols * sizeof(float));
  cudaMemcpy(d_map, map, rows * cols * sizeof(float), cudaMemcpyHostToDevice);

  local_max_kernel<<<N_BLOCKS, N_THREADS>>>(d_map, rows, cols, d_bx, d_by, steps, d_state);

  cudaMemcpy(map, d_map, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(bx, d_bx, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(by, d_by, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);

  // After kernel call:
  // Need to copy data back to CPU and find max value
  float max_val = 0;
  for(int i = 0; i < N_BLOCKS * N_THREADS; i++) {
    int x = bx[i];
    int y = by[i];
    int idx = x * 6114 + y;
    float height = map[idx];
    if (height > max_val) {
      max_val = height;
    }
  }

  // Finally: free used GPU and CPU memory
  cudaFree(d_state);
  cudaFree(d_map);
  cudaFree(d_bx);
  cudaFree(d_by);
  free(bx);
  free(by);
  return max_val;
}
float local_max_restart(float* map, int rows, int cols, int steps) {
  curandState* d_state = init_rand();
  int *bx, *by;
  int *d_bx, *d_by;
  float* d_map;

  // Before kernel call:
  // Need to allocate memory for above variables and copy data to GPU

  bx = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));
  by = (int*)malloc(N_BLOCKS * N_THREADS * sizeof(float));
  cudaMalloc(&d_bx, N_BLOCKS * N_THREADS * sizeof(float));
  cudaMalloc(&d_by, N_BLOCKS * N_THREADS * sizeof(float));

  
  cudaMalloc(&d_map, rows * cols * sizeof(float));
  cudaMemcpy(d_map, map, rows * cols * sizeof(float), cudaMemcpyHostToDevice);

  local_max_restart_kernel<<<N_BLOCKS, N_THREADS>>>(d_map, rows, cols, d_bx, d_by, steps, d_state);

  cudaMemcpy(map, d_map, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(bx, d_bx, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);
  cudaMemcpy(by, d_by, N_BLOCKS * N_THREADS * sizeof(float), cudaMemcpyDeviceToHost);

  // After kernel call:
  // Need to copy data back to CPU and find max value
  float max_val = 0;
  for(int i = 0; i < N_BLOCKS * N_THREADS; i++) {
    int x = bx[i];
    int y = by[i];
    int idx = x * 6114 + y;
    float height = map[idx];
    if (height > max_val) {
      max_val = height;
    }
  }

  // Finally: free used GPU and CPU memory
  cudaFree(d_state);
  cudaFree(d_map);
  cudaFree(d_bx);
  cudaFree(d_by);
  free(bx);
  free(by);
  return max_val;
}


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
  int steps = 1;
  while(steps <= 1024) {
    float max_val = local_max_restart(map, rows, cols, steps);
    //printf("%d %d\n", rows, cols);
    printf("with reset: %d, max value: %f\n", steps, max_val);
    steps = steps * 2;
  }
  free(map);

  return 0;
}