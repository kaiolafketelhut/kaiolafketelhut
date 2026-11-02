#include <stdio.h>
#include <string.h>

#define MODE_16BIT 0
#define MODE_X64   1

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

void inspect_payload(int mode) {
    unsigned char* ptr = (mode == MODE_16BIT) ? payload_16bit : payload_x64;
    size_t len = (mode == MODE_16BIT) ? sizeof(payload_16bit) : sizeof(payload_x64);
    
    printf("--- SDK Payload Hex Dump (%s Mode) ---\n", (mode == MODE_16BIT) ? "16-Bit" : "x64 Extension");
    for(size_t i = 0; i < len; i++) {
        printf("%02X ", ptr[i]);
    }
    printf("\n\n");
}

// Automatically dumps the machine code structure out to a local file descriptor
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
    
    if (written == len) {
        printf("[+] Successfully exported %zu bytes to %s\n", written, filename);
        return 0;
    }
    return -2;
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
    inspect_payload(MODE_X64);
    
    // Write out the current exploration target directly into main.raw
    export_raw_binary("main.raw", MODE_16BIT);
    
    return 0;
}
