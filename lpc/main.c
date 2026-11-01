/* KDP profile - LPC object (works on LDMud and FluffOS style drivers) */

#define PREFIX "KDPMember:"

string member_id, role;
int points;

/* The short code after the "KDPMember:" prefix */
string short_code(string id)
{
    int n;
    n = strlen(PREFIX);
    if (strlen(id) >= n && id[0..n-1] == PREFIX)
        return id[n..];
    return id;
}

void show_profile()
{
    write("=== KDP Forum Profile ===\n");
    write("Nickname : " + member_id + "\n");
    write("Code     : " + short_code(member_id) + "\n");
    write("Role     : " + role + "\n");
    write("Points   : " + points + "\n");
}

void create()
{
    member_id = "KDPMember:KL5UQ4f48673352";
    role = "Member";
    points = 1;
    show_profile();
}
