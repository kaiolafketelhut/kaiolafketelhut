#!/usr/bin/env python3
"""fix_sdk.py - make the compaction use the chunk table instead of "0x00 means free".

usage: python3 fix_sdk.py [SDK.c]      (keeps a backup as SDK.c.bak)
"""
import os
import re
import shutil
import sys

path = sys.argv[1] if len(sys.argv) > 1 else "SDK.c"
src = open(path).read()

NEW_FN = '''size_t defragment_midi_stream(unsigned char* pool, size_t size,
                              const OQM_PipelineQueue* queue) {
    size_t write_ptr = 0;
    printf("--- Minix VFS/MM Storage Compaction Server Loop ---\\n");
    /* Chunks are listed in ascending pool_offset order, so a forward memmove is safe.
       A 0x00 byte is real data (e.g. the 00 in "mov dx, 000Fh"), not a free hole. */
    for (size_t i = 0; i < queue->total_chunks; i++) {
        size_t off = queue->chunks[i].pool_offset;
        size_t len = queue->chunks[i].size;
        if (off + len > size) {
            printf("[-] chunk %zu does not fit in the pool\\n", i);
            return 0;
        }
        if (off != write_ptr) {
            memmove(pool + write_ptr, pool + off, len);
        }
        write_ptr += len;
    }
    memset(pool + write_ptr, FREE_HOLE, size - write_ptr);
    printf("[+] Task completed. Active allocation footprint: %zu bytes\\n", write_ptr);
    return write_ptr;
}
'''

out, n1 = re.subn(r"size_t defragment_midi_stream\(.*?\n\}\n", lambda m: NEW_FN, src,
                  count=1, flags=re.S)
out, n2 = re.subn(r"defragment_midi_stream\(memory_pool,\s*MEMORY_POOL_SIZE\)",
                  "defragment_midi_stream(memory_pool, MEMORY_POOL_SIZE, &pipeline)", out)
if n1 != 1 or n2 != 1:
    sys.exit("patch not applied (function matches: %d, call matches: %d); SDK.c left unchanged" % (n1, n2))
if not os.path.exists(path + ".bak"):
    shutil.copy(path, path + ".bak")      # keep the first original only
open(path, "w").write(out)
print("patched %s (backup: %s.bak)" % (path, path))
