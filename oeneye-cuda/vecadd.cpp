#include "oeneye_cuda.h"
#include <chrono>
#include <cstdio>

__global__ void vecadd(const float* a, const float* b, float* c, int n) {
  int i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i < n) c[i] = a[i] + b[i];
}

int main() {
  const int N = 1 << 20;
  float *a, *b, *c;
  oeMalloc((void**)&a, N * sizeof(float));
  oeMalloc((void**)&b, N * sizeof(float));
  oeMalloc((void**)&c, N * sizeof(float));
  for (int i = 0; i < N; i++) { a[i] = (float)i; b[i] = 2.0f * i; }
  dim3 block(256), grid((N + 255) / 256);
  auto t0 = std::chrono::steady_clock::now();
  oeLaunch(grid, block, vecadd, a, b, c, N);
  double ms = std::chrono::duration<double, std::milli>(std::chrono::steady_clock::now() - t0).count();
  int bad = 0;
  for (int i = 0; i < N; i++) if (c[i] != 3.0f * i) bad++;
  std::printf("%s: %d elements, %d wrong, %.1f ms on %u CPU threads\n",
              bad ? "FAIL" : "OK", N, bad, ms, std::thread::hardware_concurrency());
  oeFree(a); oeFree(b); oeFree(c);
  return bad != 0;
}
