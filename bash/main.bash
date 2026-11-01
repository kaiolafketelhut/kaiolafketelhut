#!/usr/bin/env bash
set -euo pipefail

declare -A me=(
    [member_id]='KDPMember:KL5UQ4f48673352'
    [role]='Member'
    [points]=1
)

# The short code after the "KDPMember:" prefix
short_code() {
    local prefix='KDPMember:'
    if [[ $1 == "$prefix"* ]]; then
        printf '%s\n' "${1#"$prefix"}"
    else
        printf '%s\n' "$1"
    fi
}

main() {
    echo '=== KDP Forum Profile ==='
    echo "Nickname : ${me[member_id]}"
    echo "Code     : $(short_code "${me[member_id]}")"
    echo "Role     : ${me[role]}"
    echo "Points   : ${me[points]}"
}

main "$@"
