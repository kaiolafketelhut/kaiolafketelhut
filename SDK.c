#include <stdio.h>
#include <string.h>

#define MODE_16BIT 0
#define MODE_X64   1

// Memory Defragmenter Mock Settings
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

// --- Core Defragmentation Algorithm ---
void defragment_memory(unsigned char* pool, size_t size) {
    size_t write_ptr = 0;
    
    printf("--- Initializing Defragmentation Algorithm Loop ---\n");
    
    // Shift phase: Move all valid non-zero block data to the front
    for (size_t read_ptr = 0; read_ptr < size; read_ptr++) {
        if (pool[read_ptr] != FREE_HOLE) {
            pool[write_ptr] = pool[read_ptr];
            if (write_ptr != read_ptr) {
                pool[read_ptr] = FREE_HOLE; // Clear old unshifted layout slot
            }
            write_ptr++;
        }
    }
    printf("[+] Memory compaction complete. Free space consolidated at address offset: %zu\n\n", write_ptr);
}

void print_pool(const char* label, unsigned char* pool, size_t size) {
    printf("Memory Pool [%s]:\n", label);
    for (size_t i = 0; i < size; i++) {
        printf("%02X ", pool[i]);
        if ((i + 1) % 16 == 0) printf("\n");
    }
    printf("\n");
}

void inspect_payload(int mode) {
    unsigned char* ptr = (mode == MODE_16BIT) ? payload_16bit : payload_x64;
    size_t len = (mode == MODE_16BIT) ? sizeof(payload_16bit) : sizeof(payload_x64);
    
    printf("--- SDK Payload Hex Dump (%s Mode) ---\n", (mode == MODE_16BIT) ? "16-Bit" : "x64 Extension");
    for(size_t i = 0; i < len; i++) {
        printf("%02X ", ptr[i]);
    }
    printf("\n\n");
}

int export_raw_binary(const char* filename, int mode) {
    unsigned char* ptr = (mode == MODE_16BIT) ? payload_16bit : payload_x64;
    size_t len = (mode == MODE_16BIT) ? sizeof(payload_16bit) : sizeof(payload_x64);
    
    FILE* file = fopen(filename, "wb");
    if (!file) {
        printf("[-] Failed to open target file for writing: %s\n", filename);
        return -1;
    }
    
    size_t written = fwrite(ptr, 1, len, file);
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
    
    inspect_payload(MODE_16BIT);
    
    // --- Defragmentation Simulation Context Setup ---
    unsigned char memory_pool[MEMORY_POOL_SIZE] = {0};
    
    // Simulate a heavily fragmented sector map by inserting raw data separated by zero holes
    memcpy(memory_pool, payload_16bit, 5);           // First chunk of data
    // Leave indices 5-15 empty (fragmented holes)
    memcpy(memory_pool + 15, payload_16bit + 5, 5);  // Second chunk of data
    // Leave indices 20-30 empty
    memcpy(memory_pool + 30, payload_16bit + 10, 5); // Final chunk of data
    
    print_pool("FRAGMENTED", memory_pool, MEMORY_POOL_SIZE);
    
    // Run the compaction algorithm engine
    defragment_memory(memory_pool, MEMORY_POOL_SIZE);
    
    print_pool("COMPACTED / CLEANED", memory_pool, MEMORY_POOL_SIZE);
    
    export_raw_binary("main.raw", MODE_16BIT);
    return 0;
}
