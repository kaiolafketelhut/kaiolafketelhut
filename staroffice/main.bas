REM  *****  BASIC  *****
Option Explicit

Const PREFIX = "KDPMember:"

' The short code after the "KDPMember:" prefix
Function ShortCode(id As String) As String
    If Left(id, Len(PREFIX)) = PREFIX Then
        ShortCode = Mid(id, Len(PREFIX) + 1)
    Else
        ShortCode = id
    End If
End Function

Sub Main
    Dim memberId As String
    Dim role As String
    Dim points As Integer
    Dim msg As String

    memberId = "KDPMember:KL5UQ4f48673352"
    role = "Member"
    points = 1

    msg = "=== KDP Forum Profile ===" & Chr(10) & _
          "Nickname : " & memberId & Chr(10) & _
          "Code     : " & ShortCode(memberId) & Chr(10) & _
          "Role     : " & role & Chr(10) & _
          "Points   : " & points
    MsgBox msg
End Sub
