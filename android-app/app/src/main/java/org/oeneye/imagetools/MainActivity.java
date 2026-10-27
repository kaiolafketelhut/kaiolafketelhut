package org.oeneye.imagetools;
import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.widget.*;
import java.io.*;
public class MainActivity extends Activity {
  TextView out; File img;
  protected void onCreate(Bundle b) {
    super.onCreate(b);
    LinearLayout l = new LinearLayout(this);
    l.setOrientation(LinearLayout.VERTICAL);
    l.setPadding(32, 32, 32, 32);
    Button pick = btn("Pick disk image"), info = btn("Show info"), chk = btn("Check image"), conv = btn("Convert to qcow2");
    out = new TextView(this);
    out.setTextIsSelectable(true);
    out.setText("Pick a disk image (raw, qcow2, vmdk, vdi, vhd...).");
    ScrollView s = new ScrollView(this);
    s.addView(out);
    for (Button x : new Button[]{pick, info, chk, conv}) l.addView(x);
    l.addView(s);
    setContentView(l);
    pick.setOnClickListener(v -> {
      Intent i = new Intent(Intent.ACTION_OPEN_DOCUMENT);
      i.addCategory(Intent.CATEGORY_OPENABLE);
      i.setType("*/*");
      startActivityForResult(i, 1);
    });
    info.setOnClickListener(v -> run("info", img));
    chk.setOnClickListener(v -> run("check", img));
    conv.setOnClickListener(v -> run("convert", img));
  }
  Button btn(String t) { Button x = new Button(this); x.setText(t); return x; }
  protected void onActivityResult(int rq, int rs, Intent d) {
    if (rq != 1 || rs != RESULT_OK || d == null) return;
    Uri u = d.getData();
    out.setText("Copying image...");
    new Thread(() -> {
      try {
        File f = new File(getCacheDir(), "input.img");
        try (InputStream in = getContentResolver().openInputStream(u); OutputStream o = new FileOutputStream(f)) {
          byte[] buf = new byte[1 << 16]; int n;
          while ((n = in.read(buf)) > 0) o.write(buf, 0, n);
        }
        img = f;
        runOnUiThread(() -> out.setText("Loaded " + f.length() + " bytes. Choose an action."));
      } catch (Exception e) { runOnUiThread(() -> out.setText("Error: " + e)); }
    }).start();
  }
  void run(String cmd, File f) {
    if (f == null) { out.setText("Pick an image first."); return; }
    out.setText("Running...");
    new Thread(() -> {
      try {
        String bin = getApplicationInfo().nativeLibraryDir + "/libqemu-img.so";
        File res = new File(getExternalFilesDir(null), "converted.qcow2");
        ProcessBuilder pb = cmd.equals("convert")
          ? new ProcessBuilder(bin, "convert", "-p", "-O", "qcow2", f.getPath(), res.getPath())
          : new ProcessBuilder(bin, cmd, f.getPath());
        pb.redirectErrorStream(true);
        Process p = pb.start();
        StringBuilder sb = new StringBuilder();
        try (BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()))) {
          String ln;
          while ((ln = r.readLine()) != null) sb.append(ln).append("\n");
        }
        int rc = p.waitFor();
        if (cmd.equals("convert") && rc == 0) sb.append("\nSaved: ").append(res.getPath());
        String t = sb.toString() + "\n(exit " + rc + ")";
        runOnUiThread(() -> out.setText(t));
      } catch (Exception e) { runOnUiThread(() -> out.setText("Error: " + e)); }
    }).start();
  }
}
