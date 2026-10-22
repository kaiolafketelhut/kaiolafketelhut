// oeneye_cuda.h - tiny CPU-backed, CUDA-style kernel runtime (original code, no NVIDIA headers)
#pragma once
#include <algorithm>
#include <atomic>
#include <condition_variable>
#include <cstdlib>
#include <cstring>
#include <map>
#include <memory>
#include <mutex>
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

inline int oeMalloc(void** p, size_t n) { *p = std::malloc(n); return *p ? 0 : 1; }
inline int oeFree(void* p) { std::free(p); return 0; }
inline int oeMemcpy(void* dst, const void* src, size_t n) { std::memcpy(dst, src, n); return 0; }
inline int oeMemset(void* p, int v, size_t n) { std::memset(p, v, n); return 0; }

// Fast path: no barriers. Threads of a block run one after another.
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

// ---- barrier + shared memory support ----
struct OeBlock {
  unsigned count, waiting = 0, generation = 0;
  std::mutex m;
  std::condition_variable cv;
  std::map<int, std::unique_ptr<char[]>> shared;
  explicit OeBlock(unsigned c) : count(c) {}
  void sync() {
    std::unique_lock<std::mutex> lk(m);
    unsigned g = generation;
    if (++waiting == count) { waiting = 0; generation++; cv.notify_all(); }
    else cv.wait(lk, [&] { return g != generation; });
  }
  // a thread that finished no longer counts toward the barrier (undefined behaviour in real CUDA)
  void leave() {
    std::lock_guard<std::mutex> lk(m);
    count--;
    if (count > 0 && waiting == count) { waiting = 0; generation++; cv.notify_all(); }
  }
  void* get(int id, size_t bytes) {
    std::lock_guard<std::mutex> lk(m);
    auto& p = shared[id];
    if (!p) p.reset(new char[bytes]());
    return p.get();
  }
};

inline thread_local OeBlock* oe_cur = nullptr;
inline void __syncthreads() { oe_cur->sync(); }
template <class T> T* oeShared(int id, size_t n) { return (T*)oe_cur->get(id, n * sizeof(T)); }

// Barrier path: one OS thread per CUDA thread, a few blocks in flight at once.
template <class F, class... A>
void oeLaunchSync(dim3 grid, dim3 block, F kernel, A... args) {
  gridDim = grid;
  blockDim = block;
  const unsigned total = grid.x * grid.y * grid.z;
  const unsigned per = block.x * block.y * block.z;
  std::atomic<unsigned> next{0};
  const unsigned nw = std::max(1u, std::min(4u, std::thread::hardware_concurrency()));
  std::vector<std::thread> workers;
  for (unsigned w = 0; w < nw; w++) {
    workers.emplace_back([&] {
      for (;;) {
        unsigned i = next.fetch_add(1);
        if (i >= total) break;
        dim3 bi(i % grid.x, (i / grid.x) % grid.y, i / (grid.x * grid.y));
        OeBlock blk(per);
        std::vector<std::thread> ts;
        for (unsigned z = 0; z < block.z; z++)
          for (unsigned y = 0; y < block.y; y++)
            for (unsigned x = 0; x < block.x; x++)
              ts.emplace_back([&, x, y, z, bi] {
                oe_cur = &blk;
                threadIdx = dim3(x, y, z);
                blockIdx = bi;
                kernel(args...);
                blk.leave();
              });
        for (auto& t : ts) t.join();
      }
    });
  }
  for (auto& w : workers) w.join();
}
