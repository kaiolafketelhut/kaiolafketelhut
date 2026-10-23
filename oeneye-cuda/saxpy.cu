#include <cstdio>
__global__ void saxpy(int n, float a, const float* x, float* y) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) y[i] = a * x[i] + y[i];
}
int main() {
  const int n = 1 << 18;
  float *x, *y;
  cudaMalloc(&x, n * sizeof(float));
  cudaMalloc(&y, n * sizeof(float));
  for (int i = 0; i < n; i++) { x[i] = 1.0f; y[i] = 2.0f; }
  saxpy<<<(n + 255) / 256, 256>>>(n, 3.0f, x, y);
  cudaDeviceSynchronize();
  int bad = 0;
  for (int i = 0; i < n; i++) if (y[i] != 5.0f) bad++;
  printf("%s saxpy via <<< >>>: %d wrong\n", bad ? "FAIL" : "OK", bad);
  cudaFree(x); cudaFree(y);
  return bad != 0;
}
