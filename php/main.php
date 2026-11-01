<?php
declare(strict_types=1);

final class KdpMember
{
    public function __construct(
        public string $memberId,
        public string $role,
        public int $points,
    ) {}

    // The short code after the "KDPMember:" prefix
    public function shortCode(): string
    {
        $prefix = 'KDPMember:';
        return str_starts_with($this->memberId, $prefix)
            ? substr($this->memberId, strlen($prefix))
            : $this->memberId;
    }
}

$me = new KdpMember('KDPMember:KL5UQ4f48673352', 'Member', 1);

echo "=== KDP Forum Profile ===\n";
echo "Nickname : {$me->memberId}\n";
echo "Code     : {$me->shortCode()}\n";
echo "Role     : {$me->role}\n";
echo "Points   : {$me->points}\n";
