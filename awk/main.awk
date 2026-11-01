#!/usr/bin/awk -f

# The short code after the "KDPMember:" prefix
function short_code(id,    prefix) {
    prefix = "KDPMember:"
    if (index(id, prefix) == 1)
        return substr(id, length(prefix) + 1)
    return id
}

BEGIN {
    member_id = "KDPMember:KL5UQ4f48673352"
    role      = "Member"
    points    = 1

    print "=== KDP Forum Profile ==="
    print "Nickname : " member_id
    print "Code     : " short_code(member_id)
    print "Role     : " role
    print "Points   : " points
}
