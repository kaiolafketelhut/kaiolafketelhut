import std.stdio;
import std.file;
import std.zlib;
import std.bitmanip;
import std.math;
void main() {
    int w = 120, h = 64;
    ubyte[] raw;
    foreach (y; 0..h) {
        foreach (x; 0..w) {
            ubyte v = 0;
            // body: wide round pacman frog
            double b = ((x-60.0)*(x-60.0))/(28.0*28.0) + ((y-40.0)*(y-40.0))/(16.0*16.0);
            if (b < 1) v = 255;
            // head: wide
            if (sqrt(cast(double)((x-60)*(x-60) + (y-30)*(y-30))) < 18) v = 255;
            // horns: 2 triangles on top - pointy eyelids
            if (x >= 46 && x <= 50 && y >= 10 && y <= 18) v = 255;
            if (x >= 48 && x <= 50 && y >= 12 && y <= 18) v = 255;
            if (x >= 70 && x <= 74 && y >= 10 && y <= 18) v = 255;
            if (x >= 70 && x <= 72 && y >= 12 && y <= 18) v = 255;
            // eyes: 2 circles under horns
            if (sqrt(cast(double)((x-48)*(x-48) + (y-20)*(y-20))) < 4) v = 255;
            if (sqrt(cast(double)((x-48)*(x-48) + (y-20)*(y-20))) < 1.5) v = 0;
            if (sqrt(cast(double)((x-72)*(x-72) + (y-20)*(y-20))) < 4) v = 255;
            if (sqrt(cast(double)((x-72)*(x-72) + (y-20)*(y-20))) < 1.5) v = 0;
            // HUGE mouth: very wide bar - pacman eats everything
            if (x >= 40 && x <= 80 && y >= 32 && y <= 34) v = 0;
            // belly: bar
            if (x >= 44 && x <= 76 && y >= 48 && y <= 50) v = 0;
            // front legs: 2 bars
            if (x >= 44 && x <= 48 && y >= 50 && y <= 56) v = 255;
            if (x >= 72 && x <= 76 && y >= 50 && y <= 56) v = 255;
            // ground: bar
            if (x >= 30 && x <= 90 && y >= 56 && y <= 58) v = 255;
            raw ~= v;
        }
    }
    ubyte[] header = cast(ubyte[])"XIMG" ~ [cast(ubyte)1, cast(ubyte)1];
    header ~= nativeToLittleEndian(cast(int)w);
    header ~= nativeToLittleEndian(cast(int)h);
    auto comp = compress(raw);
    std.file.write("rm68.ximg", header ~ comp);
    std.file.write("rm68.raw", raw);
    writefln("made rm68.ximg %s bytes, raw %s bytes", header.length + comp.length, raw.length);
}
