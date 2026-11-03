#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <stdlib.h>
#include "OQM.h"

#define MEMORY_POOL_SIZE 64
#define FREE_HOLE        0x00

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

// Bounded FAT77 Task: Defragmenter Server Module with Flag Validation Logic
size_t defragment_midi_stream(unsigned char* pool, size_t size, const OQM_PipelineQueue* queue) {
    size_t write_ptr = 0;
    char input_buffer[10];

    printf("--- FAT77 Storage Protection & Compaction Server Loop ---\n");
    
    for (size_t i = 0; i < queue->total_chunks; i++) {
        size_t off = queue->chunks[i].pool_offset;
        size_t len = queue->chunks[i].size;
        uint8_t flags = queue->chunks[i].flags;

        // Interactive STEP CLI Hook Execution Loop
        printf("\n[STEP CLI] Ready to process Chunk %zu (Offset: %zu, Size: %zu bytes)\n", i, off, len);
        printf(" -> Cluster Attribute Flags: [ %s%s%s]\n", 
               (flags & FAT77_ATTR_ALLOC) ? "ALLOCATED " : "",
               (flags & FAT77_ATTR_READONLY) ? "READ_ONLY " : "",
               (flags & FAT77_ATTR_SYSTEM) ? "SYSTEM_RESERVED " : "");
        printf(" Press [ENTER] to advance memory loop operation...\n");
        fgets(input_buffer, sizeof(input_buffer), stdin);

        // Protection check: Refuse execution if bounds breach structural allocations
        if (off + len > size) {
            printf("[-] FATAL FAULT: Chunk %zu overflows allocated memory space.\n", i);
            return 0;
        }

        // Flag Check: Rejects processing if System Flag blocks structural relocation updates
        if (flags & FAT77_ATTR_SYSTEM) {
            printf("[!] FAT77 FAULT: Sector locked down. Skipping system protection cluster block.\n");
            // Jump write pointer past locked block to prevent data corruption overwrites
            write_ptr = off + len; 
            continue;
        }

        if (off != write_ptr) {
            memmove(pool + write_ptr, pool + off, len);
        }
        write_ptr += len;
        
        print_midi_pool("ACTIVE TRANSITION STEP", pool, MEMORY_POOL_SIZE);
    }
    
    // Clear out trailing blocks left behind after migration
    memset(pool + write_ptr, FREE_HOLE, size - write_ptr);
    printf("[+] Task completed. Active allocation footprint: %zu bytes\n\n", write_ptr);
    return write_ptr;
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
    pipeline.total_chunks = 3;
    
    // Chunk 0: Allocated Standard Operations Byte Layer Block
    pipeline.chunks[0].data_ptr = active_payload;
    pipeline.chunks[0].size = 5;
    pipeline.chunks[0].pool_offset = 0;
    pipeline.chunks[0].flags = FAT77_ATTR_ALLOC;
    
    // Chunk 1: Read-Only Operations Layer Block
    pipeline.chunks[1].data_ptr = active_payload + 5;
    pipeline.chunks[1].size = 5;
    pipeline.chunks[1].pool_offset = 15;
    pipeline.chunks[1].flags = FAT77_ATTR_ALLOC | FAT77_ATTR_READONLY;
    
    // Chunk 2: Protected Core Microkernel Sector Map Block
    pipeline.chunks[2].data_ptr = active_payload + 10;
    pipeline.chunks[2].size = payload_len - 10;
    pipeline.chunks[2].pool_offset = 30;
    pipeline.chunks[2].flags = FAT77_ATTR_ALLOC | FAT77_ATTR_SYSTEM;
    
    for (size_t i = 0; i < pipeline.total_chunks; i++) {
        memcpy(memory_pool + pipeline.chunks[i].pool_offset, 
               pipeline.chunks[i].data_ptr, 
               pipeline.chunks[i].size);
    }
    
    print_midi_pool("FRAGMENTED SECTOR ALLOCATIONS", memory_pool, MEMORY_POOL_SIZE);
    
    // Run the interactive metadata defragmenter loop
    size_t clean_length = defragment_midi_stream(memory_pool, MEMORY_POOL_SIZE, &pipeline);
    
    print_midi_pool("FINAL COMPACTED STORAGE", memory_pool, MEMORY_POOL_SIZE);
    
    // Note: Due to SYSTEM cluster lockdown skipping compaction, checksum is verified via direct array
    uint32_t compacted_checksum = calculate_midi_checksum(memory_pool, clean_length);
    printf("[*] Compacted Channel Checksum: 0x%08X\n", compacted_checksum);
    
    printf("[+] FAT77 Driver Processing Routine Finished Successfully.\n\n");
    return 0;
}
