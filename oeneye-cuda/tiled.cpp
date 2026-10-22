#include "oeneye_cuda.h"
#include <chrono>
#include <cstdio>

__global__ void matmul_tiled(const float* a, const float* b, float* c, int n) {
  const unsigned T = blockDim.x;
  float* As = oeShared<float>(0, T * T);
  float* Bs = oeShared<float>(1, T * T);
  unsigned row = blockIdx.y * T + threadIdx.y;
  unsigned col = blockIdx.x * T + threadIdx.x;
  float s = 0;
  for (unsigned t = 0; t < (n + T - 1) / T; t++) {
    unsigned ac = t * T + threadIdx.x, br = t * T + threadIdx.y;
    As[threadIdx.y * T + threadIdx.x] = (row < (unsigned)n && ac < (unsigned)n) ? a[row * n + ac] : 0.0f;
    Bs[threadIdx.y * T + threadIdx.x] = (br < (unsigned)n && col < (unsigned)n) ? b[br * n + col] : 0.0f;
    __syncthreads();
    for (unsigned k = 0; k < T; k++) s += As[threadIdx.y * T + k] * Bs[k * T + threadIdx.x];
    __syncthreads();
  }
  if (row < (unsigned)n && col < (unsigned)n) c[row * n + col] = s;
}

int main() {
  const int n = 64, T = 16;
  float *a, *b, *c;
  oeMalloc((void**)&a, n * n * sizeof(float));
  oeMalloc((void**)&b, n * n * sizeof(float));
  oeMalloc((void**)&c, n * n * sizeof(float));
  for (int i = 0; i < n * n; i++) { a[i] = (float)(i % 7); b[i] = (float)(i % 5); }
  auto t0 = std::chrono::steady_clock::now();
  oeLaunchSync(dim3((n + T - 1) / T, (n + T - 1) / T), dim3(T, T), matmul_tiled, a, b, c, n);
  double ms = std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count();
  int bad = 0;
  for (int r = 0; r < n; r++)
    for (int q = 0; q < n; q++) {
      float s = 0;
      for (int k = 0; k < n; k++) s += a[r * n + k] * b[k * n + q];
      if (c[r * n + q] != s) bad++;
    }
  std::printf("%s tiled matmul: %dx%d, %d wrong, %.1f ms\n", bad ? "FAIL" : "OK", n, n, bad, ms);
  oeFree(a); oeFree(b); oeFree(c);
  return bad != 0;
}
