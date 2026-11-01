#!/bin/sh

prefix='KDPMember:'
member_id='KDPMember:KL5UQ4f48673352'
role='Member'
points=1

# The short code after the "KDPMember:" prefix
short_code() {
    case $1 in
        "$prefix"*) printf '%s\n' "${1#"$prefix"}" ;;
        *)          printf '%s\n' "$1" ;;
    esac
}

echo '=== KDP Forum Profile ==='
echo "Nickname : $member_id"
echo "Code     : $(short_code "$member_id")"
echo "Role     : $role"
echo "Points   : $points"
