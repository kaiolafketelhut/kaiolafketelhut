class KdpMember {
    has Str $.member-id;
    has Str $.role;
    has Int $.points;

    # The short code after the "KDPMember:" prefix
    method short-code(--> Str) {
        my $prefix = 'KDPMember:';
        $!member-id.starts-with($prefix)
            ?? $!member-id.substr($prefix.chars)
            !! $!member-id;
    }
}

sub MAIN() {
    my $me = KdpMember.new(
        member-id => 'KDPMember:KL5UQ4f48673352',
        role      => 'Member',
        points    => 1,
    );

    say '=== KDP Forum Profile ===';
    say 'Nickname : ', $me.member-id;
    say 'Code     : ', $me.short-code;
    say 'Role     : ', $me.role;
    say 'Points   : ', $me.points;
}
