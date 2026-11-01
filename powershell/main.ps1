$Prefix = 'KDPMember:'

# The short code after the "KDPMember:" prefix
function Get-ShortCode {
    param([string]$Id)
    if ($Id.StartsWith($Prefix)) {
        return $Id.Substring($Prefix.Length)
    }
    return $Id
}

$me = [pscustomobject]@{
    MemberId = 'KDPMember:KL5UQ4f48673352'
    Role     = 'Member'
    Points   = 1
}

Write-Output '=== KDP Forum Profile ==='
Write-Output "Nickname : $($me.MemberId)"
Write-Output "Code     : $(Get-ShortCode $me.MemberId)"
Write-Output "Role     : $($me.Role)"
Write-Output "Points   : $($me.Points)"
