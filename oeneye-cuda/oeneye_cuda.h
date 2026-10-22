// oeneye_cuda.h - tiny CPU-backed, CUDA-style kernel runtime (original code, no NVIDIA headers)
#pragma once
#include <atomic>
#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <thread>
#include <vector>

#define __global__
#define __device__
#define __host__

struct dim3 {
  unsigned x, y, z;
  dim3(unsigned x_ = 1, unsigned y_ = 1, unsigned z_ = 1) : x(x_), y(y_), z(z_) {}
};

inline thread_local dim3 threadIdx;
inline thread_local dim3 blockIdx;
inline dim3 blockDim;
inline dim3 gridDim;

// device memory is just host memory in this backend
inline int oeMalloc(void** p, size_t n) { *p = std::malloc(n); return *p ? 0 : 1; }
inline int oeFree(void* p) { std::free(p); return 0; }
inline int oeMemcpy(void* dst, const void* src, size_t n) { std::memcpy(dst, src, n); return 0; }
inline int oeMemset(void* p, int v, size_t n) { std::memset(p, v, n); return 0; }

// oeLaunch(grid, block, kernel, args...) plays the role of kernel<<<grid, block>>>(args...)
template <class F, class... A>
void oeLaunch(dim3 grid, dim3 block, F kernel, A... args) {
  gridDim = grid;
  blockDim = block;
  const unsigned total = grid.x * grid.y * grid.z;
  std::atomic<unsigned> next{0};
  const unsigned n = std::max(1u, std::thread::hardware_concurrency());
  std::vector<std::thread> workers;
  for (unsigned t = 0; t < n; t++) {
    workers.emplace_back([&] {
      for (;;) {
        unsigned i = next.fetch_add(1);
        if (i >= total) break;
        blockIdx = dim3(i % grid.x, (i / grid.x) % grid.y, i / (grid.x * grid.y));
        for (unsigned z = 0; z < block.z; z++)
          for (unsigned y = 0; y < block.y; y++)
            for (unsigned x = 0; x < block.x; x++) {
              threadIdx = dim3(x, y, z);
              kernel(args...);
            }
      }
    });
  }
  for (auto& w : workers) w.join();
}
