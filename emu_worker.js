importScripts('https://cdn.jsdelivr.net/pyodide/v0.26.4/full/pyodide.js');
var py=null;
onmessage=async function(e){
  var out=[], enc=new TextEncoder(), dec=new TextDecoder();
  try{
    if(!py) py=await loadPyodide({indexURL:'https://cdn.jsdelivr.net/pyodide/v0.26.4/full/'});
    var q=e.data.lines.slice();
    py.setStdout({raw:function(b){out.push(b);}});
    py.setStderr({raw:function(b){out.push(b);}});
    py.setStdin({stdin:function(){
      if(!q.length) return null;
      var l=q.shift();
      enc.encode(l+'\n').forEach(function(b){out.push(b);});
      return l;
    }});
    py.FS.writeFile('emu_dos.py', e.data.code);
    py.runPython("import runpy");
    py.runPython("runpy.run_path('emu_dos.py', run_name='__main__')");
    postMessage({out:dec.decode(new Uint8Array(out))+'\n[program finished]'});
  }catch(err){
    var m=String(err&&err.message||err);
    var t=dec.decode(new Uint8Array(out));
    var s=m.indexOf('SystemExit')>=0?'\n[program exited]':(m.indexOf('EOFError')>=0?'\n[no more input: type commands in the box and press Run again]':'\n[error] '+m);
    postMessage({out:t+s});
  }
};
