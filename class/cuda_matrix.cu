#include <cuda.h>
#include <cuda_runtime.h>
#include <stdio.h>

// Function to check CUDA errors
static void cuda_error(const char *msg) {
  cudaError_t err = cudaGetLastError();
  if (err != cudaSuccess) {
    fprintf(stderr, "CUDA error: %s (%s)\n", msg, cudaGetErrorName(err));
    exit(1);
  }
}

__global__ void matrixMul(float *A, float *B, float *C, int n) {
  int row = blockIdx.y * blockDim.y + threadIdx.y;
  int col = blockIdx.x * blockDim.x + threadIdx.x;

  float sum = 0.0f;
  if (row < n && col < n) {
    for (int k = 0; k < n; k++) {
      sum += A[row * n + k] * B[k * n + col];
    }
    C[row * n + col] = sum;
  }
}

int main(int argc, char *argv[]) {
  // Matrix size (modify as needed)
  int n = 1024;

  // Allocate host memory for matrices
  float *h_A, *h_B, *h_C;
  h_A = (float *)malloc(n * n * sizeof(float));
  h_B = (float *)malloc(n * n * sizeof(float));
  h_C = (float *)malloc(n * n * sizeof(float));

  // Initialize matrices (replace with your initialization logic)
  for (int i = 0; i < n * n; i++) {
    h_A[i] = 1.0f; // Modify as needed
    h_B[i] = 2.0f; // Modify as needed
  }

  // Allocate device memory for matrices
  float *d_A, *d_B, *d_C;
  cuda_error("malloc d_A");
  cudaMalloc((void **)&d_A, n * n * sizeof(float));
  cuda_error("malloc d_B");
  cudaMalloc((void **)&d_B, n * n * sizeof(float));
  cuda_error("malloc d_C");
  cudaMalloc((void **)&d_C, n * n * sizeof(float));

  // Copy matrices from host to device
  cuda_error("memcpy d_A");
  cudaMemcpy(d_A, h_A, n * n * sizeof(float), cudaMemcpyHostToDevice);
  cuda_error("memcpy d_B");
  cudaMemcpy(d_B, h_B, n * n * sizeof(float), cudaMemcpyHostToDevice);

  // Launch kernel
  int threadsPerBlock = 256;
  int blocksPerGrid = (n + threadsPerBlock - 1) / threadsPerBlock;
  cuda_error("launch kernel");
  matrixMul<<<blocksPerGrid, threadsPerBlock>>>(d_A, d_B, d_C, n);

  // Wait for kernel to finish execution
  cudaDeviceSynchronize();

  // Copy result from device to host
  cuda_error("memcpy h_C");
  cudaMemcpy(h_C, d_C, n * n * sizeof(float), cudaMemcpyDeviceToHost);

  // Free device memory
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);

  // Print some elements of the resulting matrix (optional)
  for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
      printf("%.2f ", h_C[i * n + j]);
    }
    printf("\n");
  }

  // Free host memory
  free(h_A);
  free(h_B);
  free(h_C);

  return 0;
}
