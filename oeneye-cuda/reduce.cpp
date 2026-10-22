#include "oeneye_cuda.h"
#include <chrono>
#include <cstdio>

__global__ void reduce(const float* a, float* out, int n) {
  float* s = oeShared<float>(0, blockDim.x);
  unsigned tid = threadIdx.x;
  unsigned i = blockIdx.x * blockDim.x + tid;
  s[tid] = i < (unsigned)n ? a[i] : 0.0f;
  __syncthreads();
  for (unsigned st = blockDim.x / 2; st > 0; st >>= 1) {
    if (tid < st) s[tid] += s[tid + st];
    __syncthreads();
  }
  if (tid == 0) out[blockIdx.x] = s[0];
}

int main() {
  const int N = 1 << 16, B = 256;
  const int G = (N + B - 1) / B;
  float *a, *out;
  oeMalloc((void**)&a, N * sizeof(float));
  oeMalloc((void**)&out, G * sizeof(float));
  double expect = 0;
  for (int i = 0; i < N; i++) { a[i] = (float)(i % 10); expect += a[i]; }
  auto t0 = std::chrono::steady_clock::now();
  oeLaunchSync(dim3(G), dim3(B), reduce, a, out, N);
  double ms = std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count();
  double got = 0;
  for (int g = 0; g < G; g++) got += out[g];
  bool ok = got == expect;
  std::printf("%s reduce: sum=%.0f expected=%.0f, %d blocks x %d threads, %.1f ms\n", ok ? "OK" : "FAIL", got, expect, G, B, ms);
  oeFree(a); oeFree(out);
  return !ok;
}
