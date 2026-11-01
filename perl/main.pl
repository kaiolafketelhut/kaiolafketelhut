#!/usr/bin/env perl
use strict;
use warnings;

my %me = (
    member_id => "KDPMember:KL5UQ4f48673352",
    role      => "Member",
    points    => 1,
);

# The short code after the "KDPMember:" prefix
sub short_code {
    my ($m)    = @_;
    my $prefix = "KDPMember:";
    my $id     = $m->{member_id};
    return index($id, $prefix) == 0 ? substr($id, length $prefix) : $id;
}

print "=== KDP Forum Profile ===\n";
print "Nickname : $me{member_id}\n";
print "Code     : ", short_code(\%me), "\n";
print "Role     : $me{role}\n";
print "Points   : $me{points}\n";
