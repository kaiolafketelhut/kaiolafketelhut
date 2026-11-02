#include <stdio.h>
#include <string.h>

#define MODE_16BIT 0
#define MODE_X64   1

// SDK Identity Context
const char* ID = "KDPMember:KL5UQ4f48673352";
const char* PROFILE_TEMPLATE = 
    "=== KDP Forum Profile ===\r\n"
    "Nickname : %s\r\n"
    "Code     : %s\r\n"
    "Role     : Member\r\n"
    "Points   : 1\r\n";

// Raw Opcodes from the analysis pipeline
unsigned char payload_16bit[] = {
    0x0E,             // push cs
    0x1F,             // pop ds
    0x48,             // dec ax
    0xBA, 0x0F, 0x00, // mov dx, msg payload offset (15 bytes)
    0xB4, 0x09,       // mov ah, 9
    0xCD, 0x21,       // int 21h
    0xB8, 0x00, 0x4C, // mov ax, 4C00h
    0xCD, 0x21        // int 21h
};

unsigned char payload_x64[] = {
    0x48, 0xC7, 0xC0, 0x01, 0x00, 0x00, 0x00, // mov rax, 1 (Using 0x48 prefix)
    0xBA, 0x10, 0x00,                         // mov dx, msg payload offset (16 bytes)
    0xB4, 0x09,                               // mov ah, 9
    0xCD, 0x21,                               // int 21h
    0xB8, 0x00, 0x4C,                         // mov ax, 4C00h
    0xCD, 0x21                                // int 21h
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
    
    return 0;
}
