program Qxd;
{ qxd.pas - tiny QxD interpreter: qxd file.iQxD }
{$mode objfpc}{$H+}

uses SysUtils, Classes;

var
  Keys, Vals: TStringList;
  Src: TextFile;
  Line, Node, Field, Value, Inner, Pair: string;
  InMain: Boolean;
  P: Integer;

function Unq(const S: string): string;
begin
  Result := S;
  if (Length(Result) > 0) and (Result[1] = '"') then
    Delete(Result, 1, 1);
  if (Length(Result) > 0) and (Result[Length(Result)] = '"') then
    Delete(Result, Length(Result), 1);
end;

procedure Store(const N, F, V: string);
begin
  Keys.Add(N + '|' + F);
  Vals.Add(V);
end;

{ Node[NAME].Field[.sub] -> value }
function Lookup(const Ref: string): string;
var
  N, F, V: string;
  Q, Idx: Integer;
begin
  Result := '';
  Q := Pos('].', Ref);
  if (Copy(Ref, 1, 5) <> 'Node[') or (Q = 0) then Exit;
  N := Copy(Ref, 6, Q - 6);
  F := Copy(Ref, Q + 2, MaxInt);
  Idx := Keys.IndexOf(N + '|' + F);
  if Idx < 0 then Exit;
  V := Vals[Idx];
  Q := Pos(' -> ', V);
  while Q > 0 do
  begin
    V := Copy(V, Q + 4, MaxInt);
    Q := Pos(' -> ', V);
  end;
  Result := Unq(V);
end;

{ print "text" Node[X].Field }
procedure RunPrint(Rest: string);
var
  Text, Ref: string;
  Q: Integer;
begin
  Text := '';
  Ref := Rest;
  if (Length(Rest) > 0) and (Rest[1] = '"') then
  begin
    Delete(Rest, 1, 1);
    Q := Pos('"', Rest);
    Text := Copy(Rest, 1, Q - 1);
    Ref := Trim(Copy(Rest, Q + 1, MaxInt));
  end;
  if Ref <> '' then
    Writeln(Text, Lookup(Ref))
  else
    Writeln(Text);
end;

begin
  if ParamCount < 1 then
  begin
    Writeln(StdErr, 'usage: qxd file.iQxD');
    Halt(1);
  end;

  Keys := TStringList.Create;
  Keys.CaseSensitive := True;
  Vals := TStringList.Create;

  AssignFile(Src, ParamStr(1));
  Reset(Src);
  Node := '';
  InMain := False;

  while not Eof(Src) do
  begin
    Readln(Src, Line);
    Line := Trim(Line);
    if (Line = '') or (Copy(Line, 1, 2) = '//') then Continue;

    if (Copy(Line, 1, 5) = 'Node[') and (Copy(Line, Length(Line) - 1, 2) = ' {') then
    begin
      P := Pos(']', Line);
      Node := Copy(Line, 6, P - 6);
      Continue;
    end;
    if Line = 'main {' then begin InMain := True; Continue; end;
    if Line = '}' then begin Node := ''; InMain := False; Continue; end;

    if InMain then
    begin
      if Copy(Line, 1, 6) = 'print ' then RunPrint(Copy(Line, 7, MaxInt));
      Continue;
    end;
    if Node = '' then Continue;

    P := Pos(':', Line);
    if P = 0 then Continue;
    Field := Trim(Copy(Line, 1, P - 1));
    Value := Trim(Copy(Line, P + 1, MaxInt));
    Store(Node, Field, Value);

    { { key: val, key: val } also stores Field.key }
    if (Length(Value) > 1) and (Value[1] = '{') and
       (Value[Length(Value)] = '}') and (Pos(':', Value) > 0) then
    begin
      Inner := Copy(Value, 2, Length(Value) - 2);
      while Inner <> '' do
      begin
        P := Pos(',', Inner);
        if P = 0 then
        begin
          Pair := Inner;
          Inner := '';
        end
        else
        begin
          Pair := Copy(Inner, 1, P - 1);
          Delete(Inner, 1, P);
        end;
        P := Pos(':', Pair);
        if P > 0 then
          Store(Node, Field + '.' + Trim(Copy(Pair, 1, P - 1)),
                Trim(Copy(Pair, P + 1, MaxInt)));
      end;
    end;
  end;
  CloseFile(Src);
end.
