#include <stdio.h>
#include <string.h>

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

void defragment_memory(unsigned char* pool, size_t size) {
    size_t write_ptr = 0;
    printf("--- Initializing Defragmentation Algorithm Loop ---\n");
    for (size_t read_ptr = 0; read_ptr < size; read_ptr++) {
        if (pool[read_ptr] != FREE_HOLE) {
            pool[write_ptr] = pool[read_ptr];
            if (write_ptr != read_ptr) {
                pool[read_ptr] = FREE_HOLE;
            }
            write_ptr++;
        }
    }
    printf("[+] Memory compaction complete. Consolidated free address offset: %zu\n\n", write_ptr);
}

void print_pool(const char* label, unsigned char* pool, size_t size) {
    printf("Memory Pool [%s]:\n", label);
    for (size_t i = 0; i < size; i++) {
        printf("%02X ", pool[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");
}

int export_raw_binary(const char* filename, unsigned char* payload, size_t len) {
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("[-] Failed to open target file for writing: %s\n", filename);
        return -1;
    }
    size_t written = fwrite(payload, 1, len, file);
    fclose(file);
    return (written == len) ? 0 : -2;
}

int main(void) {
    char clean_code[32] = {0};
    if (strlen(ID) > 10) {
        strncpy(clean_code, ID + 10, sizeof(clean_code) - 1);
    }
    
    printf("--- SDK Profile Verification Initialization ---\n");
    printf(PROFILE_TEMPLATE, ID, clean_code);
    printf("\n");
    
    // Choose active payload parameters based on compilation flag passed by wrapper
    unsigned char* active_payload;
    size_t payload_len;
    
#ifdef TARGET_ARCH_X64
    active_payload = payload_x64;
    payload_len = sizeof(payload_x64);
    printf("[*] SDK Mode: x64 Targeted Architecture Payload\n\n");
#else
    active_payload = payload_16bit;
    payload_len = sizeof(payload_16bit);
    printf("[*] SDK Mode: 16-Bit Targeted Architecture Payload\n\n");
#endif

    unsigned char memory_pool[MEMORY_POOL_SIZE] = {0};
    
    // Distribute active payload blocks across pool to simulate fragmentation
    size_t chunk = payload_len / 3;
    memcpy(memory_pool, active_payload, chunk);
    memcpy(memory_pool + 15, active_payload + chunk, chunk);
    memcpy(memory_pool + 30, active_payload + (chunk * 2), payload_len - (chunk * 2));
    
    print_pool("FRAGMENTED", memory_pool, MEMORY_POOL_SIZE);
    defragment_memory(memory_pool, MEMORY_POOL_SIZE);
    print_pool("COMPACTED / CLEANED", memory_pool, MEMORY_POOL_SIZE);
    
    export_raw_binary("main.raw", active_payload, payload_len);
    return 0;
}
