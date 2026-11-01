class KdpMember
  constructor: (@memberId, @role, @points) ->

  # The short code after the "KDPMember:" prefix
  shortCode: ->
    prefix = 'KDPMember:'
    if @memberId.startsWith prefix
      @memberId.slice prefix.length
    else
      @memberId

me = new KdpMember 'KDPMember:KL5UQ4f48673352', 'Member', 1

console.log '=== KDP Forum Profile ==='
console.log "Nickname : #{me.memberId}"
console.log "Code     : #{me.shortCode()}"
console.log "Role     : #{me.role}"
console.log "Points   : #{me.points}"
