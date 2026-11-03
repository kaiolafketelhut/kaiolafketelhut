#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include "OQM.h"

#define MODE_16BIT 0
#define MODE_X64   1

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

size_t defragment_midi_stream(unsigned char* pool, size_t size) {
    size_t write_ptr = 0;
    printf("--- Minix VFS/MM Storage Compaction Server Loop ---\n");
    for (size_t read_ptr = 0; read_ptr < size; read_ptr++) {
        if (pool[read_ptr] != FREE_HOLE) {
            pool[write_ptr] = pool[read_ptr];
            if (write_ptr != read_ptr) {
                pool[read_ptr] = FREE_HOLE;
            }
            write_ptr++;
        }
    }
    printf("[+] Task completed. Active allocation footprint: %zu bytes\n\n", write_ptr);
    return write_ptr;
}

void print_midi_pool(const char* label, unsigned char* pool, size_t size) {
    printf("Server Node Block [%s]:\n", label);
    for (size_t i = 0; i < size; i++) {
        printf("%02X ", pool[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");
}

int export_raw_binary(const char* filename, unsigned char* payload, size_t len) {
    FILE* file = fopen(filename, "wb");
    if (!file) return -1;
    size_t written = fwrite(payload, 1, len, file);
    fclose(file);
    return (written == len) ? 0 : -2;
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
    
    // Explicit array indexing configuration
    pipeline.chunks[0].data_ptr = active_payload;
    pipeline.chunks[0].size = 5;
    pipeline.chunks[0].pool_offset = 0;
    
    pipeline.chunks[1].data_ptr = active_payload + 5;
    pipeline.chunks[1].size = 5;
    pipeline.chunks[1].pool_offset = 15;
    
    pipeline.chunks[2].data_ptr = active_payload + 10;
    pipeline.chunks[2].size = payload_len - 10;
    pipeline.chunks[2].pool_offset = 30;
    
    for (size_t i = 0; i < pipeline.total_chunks; i++) {
        memcpy(memory_pool + pipeline.chunks[i].pool_offset, 
               pipeline.chunks[i].data_ptr, 
               pipeline.chunks[i].size);
    }
    
    print_midi_pool("FRAGMENTED TASKS", memory_pool, MEMORY_POOL_SIZE);
    size_t clean_length = defragment_midi_stream(memory_pool, MEMORY_POOL_SIZE);
    print_midi_pool("COMPACTED STORAGE", memory_pool, MEMORY_POOL_SIZE);
    
    uint32_t compacted_checksum = calculate_midi_checksum(memory_pool, clean_length);
    printf("[*] Compacted Channel Checksum: 0x%08X\n", compacted_checksum);
    
    if (baseline_checksum == compacted_checksum) {
        printf("[+] SUCCESS: Data integrity verified. Stream matches baseline perfectly.\n\n");
    } else {
        printf("[-] ERROR: Checksum discrepancy detected.\n\n");
    }
    
    export_raw_binary("main.raw", active_payload, payload_len);
    return 0;
}
