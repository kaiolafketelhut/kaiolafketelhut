#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include <time.h>
#include "OQM.h"

#define MEMORY_POOL_SIZE 64
#define FREE_HOLE        0x00
#define MAX_CHUNKS       16

const char* ID = "KDPMember:KL5UQ4f48673352";
const char* PROFILE_TEMPLATE = 
    "=== KDP Forum Profile ===\r\n"
    "Nickname : %s\r\n"
    "Code     : %s\r\n"
    "Role     : Member\r\n"
    "Points   : 1\r\n";

unsigned char payload_16bit[] = {
    0x0E, 0x1F, 0x48, 0xBA, 0x0F, 0x00, 0xB4, 0x09, 0xCD, 0x21, 0xB8, 0x00, 0x4C, 0xCD, 0x21
};

unsigned char payload_x64[] = {
    0x48, 0xC7, 0xC0, 0x01, 0x00, 0x00, 0x00, 0xBA, 0x10, 0x00, 0xB4, 0x09, 0xCD, 0x21, 0xB8, 0x00, 0x4C, 0xCD, 0x21
};

uint32_t calculate_midi_checksum(const unsigned char* data, size_t length) {
    uint32_t checksum = 0xABCDEF;
    for (size_t i = 0; i < length; i++) {
        checksum = ((checksum << 5) + checksum) + data[i];
    }
    return checksum;
}

void print_midi_pool(const char* label, unsigned char* pool, size_t size) {
    printf("FAT77 Cluster Map [%s]:\n", label);
    for (size_t i = 0; i < size; i++) {
        printf("%02X ", pool[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");
}

size_t defragment_midi_stream(unsigned char* pool, size_t size, const OQM_PipelineQueue* queue) {
    size_t write_ptr = 0;
    char input_buffer[32];
    struct timespec start_time, end_time;

    printf("--- FAT77 Storage Protection & Compaction Server Loop ---\n");
    
    for (size_t i = 0; i < queue->total_chunks; i++) {
        size_t off = queue->chunks[i].pool_offset;
        size_t len = queue->chunks[i].size;
        uint8_t flags = queue->chunks[i].flags;

        printf("\n[STEP CLI] Ready to process Chunk %zu (Offset: %zu, Size: %zu bytes)\n", i, off, len);
        printf(" -> Cluster Attribute Flags: [ %s%s%s]\n", 
               (flags & FAT77_ATTR_ALLOC) ? "ALLOCATED " : "",
               (flags & FAT77_ATTR_READONLY) ? "READ_ONLY " : "",
               (flags & FAT77_ATTR_SYSTEM) ? "SYSTEM_RESERVED " : "");
        printf(" Press [ENTER] to execute and profile cluster operation...\n");
        fgets(input_buffer, sizeof(input_buffer), stdin);

        if (off + len > size) {
            printf("[-] FATAL FAULT: Chunk %zu overflows allocated memory space.\n", i);
            return 0;
        }

        // --- Begin High-Resolution Nanosecond Timing Frame ---
        clock_gettime(CLOCK_MONOTONIC, &start_time);

        if (flags & FAT77_ATTR_SYSTEM) {
            printf("[!] FAT77 FAULT: Sector locked down. Skipping system protection cluster block.\n");
            write_ptr = off + len; 
            clock_gettime(CLOCK_MONOTONIC, &end_time);
            goto print_metrics;
        }

        if (off != write_ptr) {
            memmove(pool + write_ptr, pool + off, len);
        }
        write_ptr += len;

        clock_gettime(CLOCK_MONOTONIC, &end_time);

    print_metrics: ;
        // Calculate dynamic timing delta metrics
        long nanoseconds = (end_time.tv_sec - start_time.tv_sec) * 1000000000L + 
                           (end_time.tv_nsec - start_time.tv_nsec);
        printf("[+] Profiler Metric: Subsystem operation completed in %ld nanoseconds.\n", nanoseconds);
        
        print_midi_pool("ACTIVE TRANSITION STEP", pool, MEMORY_POOL_SIZE);
    }
    
    memset(pool + write_ptr, FREE_HOLE, size - write_ptr);
    printf("[+] Task completed. Active allocation footprint: %zu bytes\n\n", write_ptr);
    return write_ptr;
}

int load_fat77_config(const char* filename, OQM_PipelineQueue* queue, const unsigned char* payload, size_t payload_len) {
    FILE* file = fopen(filename, "r");
    if (!file) {
        printf("[-] Error: Unable to locate config map file %s\n", filename);
        return -1;
    }

    char line[128];
    size_t count = 0;
    size_t payload_offset_counter = 0;

    printf("[*] Opening FAT77 external hardware track map parser loop...\n");
    while (fgets(line, sizeof(line), file) && count < MAX_CHUNKS) {
        if (line[0] == '#' || line[0] == '\n' || line[0] == '\r') continue;

        unsigned int off, len, flags;
        if (sscanf(line, "%u,%u,%u", &off, &len, &flags) == 3) {
            queue->chunks[count].pool_offset = off;
            queue->chunks[count].size = len;
            queue->chunks[count].flags = (uint8_t)flags;
            
            if (payload_offset_counter < payload_len) {
                queue->chunks[count].data_ptr = payload + payload_offset_counter;
                payload_offset_counter += len;
            } else {
                queue->chunks[count].data_ptr = payload;
            }
            
            printf("   Loaded Cluster Script Definition [%zu] -> Offset: %u, Size: %u, Flags: 0x%02X\n", count, off, len, flags);
            count++;
        }
    }
    fclose(file);
    queue->total_chunks = count;
    printf("[+] Configuration map parser initialization success. Count: %zu segments.\n\n", count);
    return 0;
}

int main(void) {
    char clean_code[32] = {0};
    if (strlen(ID) > 10) {
        strncpy(clean_code, ID + 10, sizeof(clean_code) - 1);
    }
    printf(PROFILE_TEMPLATE, ID, clean_code);
    
    unsigned char* active_payload;
    size_t payload_len;
    
#ifdef TARGET_ARCH_X64
    active_payload = payload_x64;
    payload_len = sizeof(payload_x64);
    printf("[*] Core Mode: Minix x64 Server Layout Mapping\n");
#else
    active_payload = payload_16bit;
    payload_len = sizeof(payload_16bit);
    printf("[*] Core Mode: Minix 16-Bit Server Layout Mapping\n");
#endif

    uint32_t baseline_checksum = calculate_midi_checksum(active_payload, payload_len);
    printf("[*] Baseline System Checksum Validation: 0x%08X\n\n", baseline_checksum);

    unsigned char memory_pool[MEMORY_POOL_SIZE] = {0};
    OQM_PipelineQueue pipeline;
    
    if (load_fat77_config("fat77.cfg", &pipeline, active_payload, payload_len) != 0) {
        return -1;
    }
    
    for (size_t i = 0; i < pipeline.total_chunks; i++) {
        memcpy(memory_pool + pipeline.chunks[i].pool_offset, 
               pipeline.chunks[i].data_ptr, 
               pipeline.chunks[i].size);
    }
    
    print_midi_pool("FRAGMENTED SECTOR ALLOCATIONS", memory_pool, MEMORY_POOL_SIZE);
    size_t clean_length = defragment_midi_stream(memory_pool, MEMORY_POOL_SIZE, &pipeline);
    print_midi_pool("FINAL COMPACTED STORAGE", memory_pool, MEMORY_POOL_SIZE);
    
    return 0;
}
