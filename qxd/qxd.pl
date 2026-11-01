#!/usr/bin/env perl
# qxd.pl - tiny QxD interpreter: perl qxd.pl file.iQxD
use strict;
use warnings;

my $src = shift or die "usage: qxd.pl file.iQxD\n";
open my $fh, '<', $src or die "$src: $!\n";

my (%db, $node);
my $inmain = 0;

sub unq { my $v = shift; $v =~ s/^"//; $v =~ s/"$//; return $v }

# Node[NAME].Field[.sub] -> value
sub lookup {
    my ($ref) = @_;
    my ($n, $f) = $ref =~ /^Node\[(.*?)\]\.(.+)$/ or return '';
    my $v = $db{$n}{$f};
    return '' unless defined $v;
    $v =~ s/^.* -> //;
    return unq($v);
}

while (my $line = <$fh>) {
    $line =~ s/^\s+|\s+$//g;
    next if $line eq '' or $line =~ m{^//};
    if ($line =~ /^Node\[(.*?)\]\s*\{$/) { $node = $1; next }
    if ($line eq 'main {') { $inmain = 1; next }
    if ($line eq '}')      { undef $node; $inmain = 0; next }

    if ($inmain) {
        next unless $line =~ /^print\s+(.*)$/;
        my $rest = $1;
        my ($text, $ref) = ('', $rest);
        ($text, $ref) = ($1, $2) if $rest =~ /^"([^"]*)"\s*(.*)$/;
        print $text, ($ref ne '' ? lookup($ref) : ''), "\n";
    }
    elsif (defined $node and $line =~ /^([^:]+?)\s*:\s*(.*)$/) {
        my ($field, $value) = ($1, $2);
        $db{$node}{$field} = $value;
        # { key: val, key: val } also stores Field.key
        if ($value =~ /^\{(.*:.*)\}$/) {
            for my $pair (split /,/, $1) {
                my ($k, $v) = $pair =~ /^\s*([^:]+?)\s*:\s*(.*?)\s*$/ or next;
                $db{$node}{"$field.$k"} = $v;
            }
        }
    }
}
