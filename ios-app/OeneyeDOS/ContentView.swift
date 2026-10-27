import SwiftUI

protocol DOSCore {
  func run(autoexec: [String], log: @escaping (String) -> Void)
}

struct StubCore: DOSCore {
  func run(autoexec: [String], log: @escaping (String) -> Void) {
    log("[core] no emulator linked yet")
    for l in autoexec { log("> " + l) }
  }
}

struct ContentView: View {
  @State private var text = "Ready."
  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      Text("Oeneye DOS").font(.title)
      Button("Boot") { boot() }.buttonStyle(.borderedProminent)
      ScrollView {
        Text(text)
          .font(.system(.footnote, design: .monospaced))
          .frame(maxWidth: .infinity, alignment: .leading)
      }
    }.padding()
  }
  func boot() {
    text = ""
    guard let u = Bundle.main.url(forResource: "autoexec", withExtension: "txt"),
          let s = try? String(contentsOf: u, encoding: .utf8) else {
      text = "autoexec.txt missing"; return
    }
    let lines = s.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
      .filter { !$0.isEmpty && !$0.hasPrefix("#") }
    if let i = Bundle.main.url(forResource: "mosfetq", withExtension: "img") {
      let n = (try? Data(contentsOf: i).count) ?? 0
      text += "floppy: mosfetq.img (\(n) bytes)\n"
    } else {
      text += "floppy image missing\n"
    }
    StubCore().run(autoexec: lines) { text += $0 + "\n" }
  }
}
