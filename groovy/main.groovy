class KdpMember {
    String memberId
    String role
    int points

    // The short code after the "KDPMember:" prefix
    String shortCode() {
        def prefix = 'KDPMember:'
        memberId.startsWith(prefix) ? memberId.substring(prefix.length()) : memberId
    }
}

def me = new KdpMember(memberId: 'KDPMember:KL5UQ4f48673352', role: 'Member', points: 1)

println '=== KDP Forum Profile ==='
println "Nickname : ${me.memberId}"
println "Code     : ${me.shortCode()}"
println "Role     : ${me.role}"
println "Points   : ${me.points}"
