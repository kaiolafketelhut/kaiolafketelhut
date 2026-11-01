#include <iostream>
#include <string>

struct KdpMember {
    std::string memberId;
    std::string role;
    int points;

    // The short code after the "KDPMember:" prefix
    std::string shortCode() const
    {
        const std::string prefix = "KDPMember:";
        return memberId.compare(0, prefix.size(), prefix) == 0
            ? memberId.substr(prefix.size())
            : memberId;
    }
};

int main()
{
    const KdpMember me{"KDPMember:KL5UQ4f48673352", "Member", 1};

    std::cout << "=== KDP Forum Profile ===\n"
              << "Nickname : " << me.memberId << "\n"
              << "Code     : " << me.shortCode() << "\n"
              << "Role     : " << me.role << "\n"
              << "Points   : " << me.points << "\n";
    return 0;
}
