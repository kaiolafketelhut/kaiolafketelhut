using System;

record KdpMember(string MemberId, string Role, int Points)
{
    // The short code after the "KDPMember:" prefix
    public string ShortCode()
    {
        const string prefix = "KDPMember:";
        return MemberId.StartsWith(prefix, StringComparison.Ordinal)
            ? MemberId.Substring(prefix.Length)
            : MemberId;
    }
}

class Program
{
    static void Main()
    {
        var me = new KdpMember("KDPMember:KL5UQ4f48673352", "Member", 1);

        Console.WriteLine("=== KDP Forum Profile ===");
        Console.WriteLine($"Nickname : {me.MemberId}");
        Console.WriteLine($"Code     : {me.ShortCode()}");
        Console.WriteLine($"Role     : {me.Role}");
        Console.WriteLine($"Points   : {me.Points}");
    }
}
