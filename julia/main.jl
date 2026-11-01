struct KdpMember
    member_id::String
    role::String
    points::Int
end

me = KdpMember("KDPMember:KL5UQ4f48673352", "Member", 1)

# The short code after the "KDPMember:" prefix
short_code(m::KdpMember) = String(chopprefix(m.member_id, "KDPMember:"))

function main()
    println("=== KDP Forum Profile ===")
    println("Nickname : ", me.member_id)
    println("Code     : ", short_code(me))
    println("Role     : ", me.role)
    println("Points   : ", me.points)
end

main()
