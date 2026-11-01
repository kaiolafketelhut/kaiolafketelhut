'use strict';

class KdpMember {
  constructor(memberId, role, points) {
    this.memberId = memberId;
    this.role = role;
    this.points = points;
  }

  // The short code after the "KDPMember:" prefix
  shortCode() {
    const prefix = 'KDPMember:';
    return this.memberId.startsWith(prefix)
      ? this.memberId.slice(prefix.length)
      : this.memberId;
  }
}

const me = new KdpMember('KDPMember:KL5UQ4f48673352', 'Member', 1);

console.log('=== KDP Forum Profile ===');
console.log(`Nickname : ${me.memberId}`);
console.log(`Code     : ${me.shortCode()}`);
console.log(`Role     : ${me.role}`);
console.log(`Points   : ${me.points}`);
