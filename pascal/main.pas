program Main;
{$mode objfpc}{$H+}

const
  Prefix = 'KDPMember:';

type
  TKdpMember = record
    MemberId: string;
    Role: string;
    Points: Integer;
  end;

// The short code after the KDPMember: prefix
function ShortCode(const M: TKdpMember): string;
begin
  if Copy(M.MemberId, 1, Length(Prefix)) = Prefix then
    Result := Copy(M.MemberId, Length(Prefix) + 1, MaxInt)
  else
    Result := M.MemberId;
end;

var
  Me: TKdpMember;
begin
  Me.MemberId := 'KDPMember:KL5UQ4f48673352';
  Me.Role := 'Member';
  Me.Points := 1;

  WriteLn('=== KDP Forum Profile ===');
  WriteLn('Nickname : ', Me.MemberId);
  WriteLn('Code     : ', ShortCode(Me));
  WriteLn('Role     : ', Me.Role);
  WriteLn('Points   : ', Me.Points);
end.
