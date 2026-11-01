from dataclasses import dataclass

PREFIX = "KDPMember:"


@dataclass(frozen=True)
class KdpMember:
    member_id: str
    role: str
    points: int

    # The short code after the "KDPMember:" prefix
    def short_code(self) -> str:
        return self.member_id.removeprefix(PREFIX)


def main() -> None:
    me = KdpMember("KDPMember:KL5UQ4f48673352", "Member", 1)

    print("=== KDP Forum Profile ===")
    print(f"Nickname : {me.member_id}")
    print(f"Code     : {me.short_code()}")
    print(f"Role     : {me.role}")
    print(f"Points   : {me.points}")


if __name__ == "__main__":
    main()
