import zipfile, hashlib, base64, struct, zlib, os
# ---- EDIT THESE (from Partner Center > Product identity) ----
NAME      = "KaiOlafKetelhut.MOSFETQemu"
PUBLISHER = "CN=PASTE-PUBLISHER-GUID-HERE"
PUBNAME   = "Kai Olaf Ketelhut"
VERSION   = "1.0.0.0"
EXE       = "omq.exe"
EXTRA     = []
OUT       = "omq.msix"
# -------------------------------------------------------------
def png(w, h, rgb):
    raw = b"".join(b"\x00" + bytes(rgb) * w for _ in range(h))
    def ch(t, d):
        c = struct.pack(">I", len(d)) + t + d
        return c + struct.pack(">I", zlib.crc32(t + d) & 0xffffffff)
    return (b"\x89PNG\r\n\x1a\n" + ch(b"IHDR", struct.pack(">IIBBBBB", w, h, 8, 2, 0, 0, 0))
            + ch(b"IDAT", zlib.compress(raw)) + ch(b"IEND", b""))
manifest = f'''<?xml version="1.0" encoding="utf-8"?>
<Package xmlns="http://schemas.microsoft.com/appx/manifest/foundation/windows10"
         xmlns:uap="http://schemas.microsoft.com/appx/manifest/uap/windows10"
         xmlns:rescap="http://schemas.microsoft.com/appx/manifest/foundation/windows10/restrictedcapabilities"
         IgnorableNamespaces="uap rescap">
  <Identity Name="{NAME}" Publisher="{PUBLISHER}" Version="{VERSION}" ProcessorArchitecture="x64" />
  <Properties>
    <DisplayName>MOSFETQemu</DisplayName>
    <PublisherDisplayName>{PUBNAME}</PublisherDisplayName>
    <Logo>Assets\\StoreLogo.png</Logo>
  </Properties>
  <Dependencies>
    <TargetDeviceFamily Name="Windows.Desktop" MinVersion="10.0.17763.0" MaxVersionTested="10.0.22621.0" />
  </Dependencies>
  <Resources><Resource Language="en-us" /></Resources>
  <Applications>
    <Application Id="MOSFETQemu" Executable="{os.path.basename(EXE)}" EntryPoint="Windows.FullTrustApplication">
      <uap:VisualElements DisplayName="MOSFETQemu" Description="MOSFETQemu"
          BackgroundColor="#141820" Square150x150Logo="Assets\\Square150x150Logo.png" Square44x44Logo="Assets\\Square44x44Logo.png">
        <uap:DefaultTile Wide310x150Logo="Assets\\Wide310x150Logo.png" />
      </uap:VisualElements>
    </Application>
  </Applications>
  <Capabilities><rescap:Capability Name="runFullTrust" /></Capabilities>
</Package>
'''.replace("\n", "\r\n").encode()
bg = (20, 24, 32)
files = {"AppxManifest.xml": manifest,
         "Assets/StoreLogo.png": png(50, 50, bg),
         "Assets/Square44x44Logo.png": png(44, 44, bg),
         "Assets/Square150x150Logo.png": png(150, 150, bg),
         "Assets/Wide310x150Logo.png": png(310, 150, bg)}
for p in [EXE] + EXTRA:
    files[os.path.basename(p)] = open(p, "rb").read()
exts = sorted({os.path.splitext(n)[1][1:].lower() for n in files if os.path.splitext(n)[1]})
mime = {"png": "image/png", "exe": "application/x-msdownload"}
ct = '<?xml version="1.0" encoding="utf-8"?>\r\n<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
for e in exts:
    if e == "xml": continue
    ct += f'<Default Extension="{e}" ContentType="{mime.get(e, "application/octet-stream")}"/>'
ct += '<Override PartName="/AppxManifest.xml" ContentType="application/vnd.ms-appx.manifest+xml"/>'
ct += '<Override PartName="/AppxBlockMap.xml" ContentType="application/vnd.ms-appx.blockmap+xml"/></Types>'
bm = ('<?xml version="1.0" encoding="UTF-8"?>\r\n<BlockMap xmlns="http://schemas.microsoft.com/appx/2010/blockmap" HashMethod="http://www.w3.org/2001/04/xmlenc#sha256">')
for n, d in files.items():
    bm += f'<File Name="{n.replace("/", chr(92))}" Size="{len(d)}" LfhSize="{30 + len(n.encode())}">'
    for i in range(0, max(len(d), 1), 65536):
        bm += '<Block Hash="%s"/>' % base64.b64encode(hashlib.sha256(d[i:i + 65536]).digest()).decode()
    bm += '</File>'
bm += '</BlockMap>'
with zipfile.ZipFile(OUT, "w", zipfile.ZIP_STORED) as z:
    for n, d in files.items(): z.writestr(n, d)
    z.writestr("AppxBlockMap.xml", bm)
    z.writestr("[Content_Types].xml", ct)
print("built", OUT, os.path.getsize(OUT), "bytes")
