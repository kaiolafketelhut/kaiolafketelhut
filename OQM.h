#ifndef OQM_H
#define OQM_H

#include <stddef.h>

typedef struct {
    const unsigned char* data_ptr;
    size_t size;
    size_t pool_offset;
} OQM_ChunkObject;

typedef struct {
    OQM_ChunkObject chunks[3]; // FIXED: Defined as an array size of 3 instead of a single object
    size_t total_chunks;
} OQM_PipelineQueue;

#endif
