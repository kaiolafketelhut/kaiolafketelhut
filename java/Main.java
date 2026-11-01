public class Main {
    record KdpMember(String memberId, String role, int points) {
        // The short code after the "KDPMember:" prefix
        String shortCode() {
            String prefix = "KDPMember:";
            return memberId.startsWith(prefix)
                ? memberId.substring(prefix.length())
                : memberId;
        }
    }

    public static void main(String[] args) {
        KdpMember me = new KdpMember("KDPMember:KL5UQ4f48673352", "Member", 1);

        System.out.println("=== KDP Forum Profile ===");
        System.out.println("Nickname : " + me.memberId());
        System.out.println("Code     : " + me.shortCode());
        System.out.println("Role     : " + me.role());
        System.out.println("Points   : " + me.points());
    }
}
