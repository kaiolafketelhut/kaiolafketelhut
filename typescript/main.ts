interface KdpMember {
  memberId: string;
  role: string;
  points: number;
}

const PREFIX = "KDPMember:";

// The short code after the "KDPMember:" prefix
function shortCode(m: KdpMember): string {
  return m.memberId.startsWith(PREFIX) ? m.memberId.slice(PREFIX.length) : m.memberId;
}

const me: KdpMember = { memberId: "KDPMember:KL5UQ4f48673352", role: "Member", points: 1 };

console.log("=== KDP Forum Profile ===");
console.log(`Nickname : ${me.memberId}`);
console.log(`Code     : ${shortCode(me)}`);
console.log(`Role     : ${me.role}`);
console.log(`Points   : ${me.points}`);
