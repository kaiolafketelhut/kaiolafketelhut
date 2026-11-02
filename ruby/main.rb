KdpMember = Struct.new(:member_id, :role, :points) do
  # The short code after the "KDPMember:" prefix
  def short_code
    member_id.delete_prefix("KDPMember:")
  end
end

me = KdpMember.new("KDPMember:KL5UQ4f48673352", "Member", 1)

puts "=== KDP Forum Profile ==="
puts "Nickname : #{me.member_id}"
puts "Code     : #{me.short_code}"
puts "Role     : #{me.role}"
puts "Points   : #{me.points}"
