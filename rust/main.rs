struct KdpMember {
    member_id: &'static str,
    role: &'static str,
    points: u32,
}

impl KdpMember {
    // The short code after the "KDPMember:" prefix
    fn short_code(&self) -> &str {
        self.member_id
            .strip_prefix("KDPMember:")
            .unwrap_or(self.member_id)
    }
}

fn main() {
    let me = KdpMember {
        member_id: "KDPMember:KL5UQ4f48673352",
        role: "Member",
        points: 1,
    };

    println!("=== KDP Forum Profile ===");
    println!("Nickname : {}", me.member_id);
    println!("Code     : {}", me.short_code());
    println!("Role     : {}", me.role);
    println!("Points   : {}", me.points);
}
