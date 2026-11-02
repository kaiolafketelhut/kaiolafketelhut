Imports System

Class KdpMember
    Public ReadOnly MemberId As String
    Public ReadOnly Role As String
    Public ReadOnly Points As Integer

    Public Sub New(id As String, r As String, p As Integer)
        MemberId = id
        Role = r
        Points = p
    End Sub

    ' The short code after the "KDPMember:" prefix
    Public Function ShortCode() As String
        Const prefix As String = "KDPMember:"
        If MemberId.StartsWith(prefix, StringComparison.Ordinal) Then
            Return MemberId.Substring(prefix.Length)
        End If
        Return MemberId
    End Function
End Class

Module Program
    Sub Main()
        Dim member As New KdpMember("KDPMember:KL5UQ4f48673352", "Member", 1)

        Console.WriteLine("=== KDP Forum Profile ===")
        Console.WriteLine($"Nickname : {member.MemberId}")
        Console.WriteLine($"Code     : {member.ShortCode()}")
        Console.WriteLine($"Role     : {member.Role}")
        Console.WriteLine($"Points   : {member.Points}")
    End Sub
End Module
