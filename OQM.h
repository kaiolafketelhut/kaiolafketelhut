#ifndef OQM_H
#define OQM_H

#include <stddef.h>
#include <stdint.h>

#define FAT77_ATTR_NONE     0x00
#define FAT77_ATTR_READONLY 0x01
#define FAT77_ATTR_ALLOC    0x02
#define FAT77_ATTR_SYSTEM   0x04

typedef struct {
    const unsigned char* data_ptr;
    size_t size;
    size_t pool_offset;
    uint8_t flags;
} OQM_ChunkObject;

typedef struct {
    OQM_ChunkObject chunks[16]; // Unified variable name tracking
    size_t total_chunks;
} OQM_PipelineQueue;

#endif
