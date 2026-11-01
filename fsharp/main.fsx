open System
open System.IO
open System.IO.Compression

let prefix = "KDPMember:"

type KdpMember =
    { MemberId: string
      Role: string
      Points: int }

    // The short code after the "KDPMember:" prefix
    member m.ShortCode =
        if m.MemberId.StartsWith prefix then m.MemberId.Substring prefix.Length
        else m.MemberId

// XIMG: "XIMG", version 1, format 1 (RGBA8), width/height u32 LE, zlib(RGBA)
let writeXimg (path: string) (w: int) (h: int) (rgba: byte[]) =
    use fs = File.Create path
    fs.Write("XIMG"B, 0, 4)
    fs.WriteByte 1uy
    fs.WriteByte 1uy
    fs.Write(BitConverter.GetBytes w, 0, 4)
    fs.Write(BitConverter.GetBytes h, 0, 4)
    use z = new ZLibStream(fs, CompressionLevel.Optimal)
    z.Write(rgba, 0, rgba.Length)

let me = { MemberId = "KDPMember:KL5UQ4f48673352"; Role = "Member"; Points = 1 }

printfn "=== KDP Forum Profile ==="
printfn "Nickname : %s" me.MemberId
printfn "Code     : %s" me.ShortCode
printfn "Role     : %s" me.Role
printfn "Points   : %d" me.Points

// One 8px column per character of the short code, color from the char value
let cell = 8
let w = me.ShortCode.Length * cell
let h = 16
let rgba = Array.zeroCreate<byte> (w * h * 4)

for x in 0 .. w - 1 do
    let c = int me.ShortCode.[x / cell]
    for y in 0 .. h - 1 do
        let i = (y * w + x) * 4
        let bar = y >= 2 && y < h - 2
        rgba.[i]     <- if bar then byte ((c * 37) % 256) else 0x14uy
        rgba.[i + 1] <- if bar then byte ((c * 91) % 256) else 0x18uy
        rgba.[i + 2] <- if bar then byte ((c * 53) % 256) else 0x20uy
        rgba.[i + 3] <- 0xFFuy

writeXimg "kdp.ximg" w h rgba
printfn "Wrote kdp.ximg (%dx%d)" w h
