#import <Foundation/Foundation.h>

@interface KdpMember : NSObject {
    NSString *memberId;
    NSString *role;
    int points;
}
- (id)initWithId:(NSString *)i role:(NSString *)r points:(int)p;
- (NSString *)shortCode;
- (NSString *)memberId;
- (NSString *)role;
- (int)points;
@end

@implementation KdpMember
- (id)initWithId:(NSString *)i role:(NSString *)r points:(int)p {
    self = [super init];
    if (self) {
        memberId = [i copy];
        role = [r copy];
        points = p;
    }
    return self;
}

// The short code after the "KDPMember:" prefix
- (NSString *)shortCode {
    NSString *prefix = @"KDPMember:";
    if ([memberId hasPrefix:prefix])
        return [memberId substringFromIndex:[prefix length]];
    return memberId;
}

- (NSString *)memberId { return memberId; }
- (NSString *)role { return role; }
- (int)points { return points; }
@end

// Print an NSString as UTF-8
static void out(NSString *s) {
    printf("%s\n", [s UTF8String]);
}

int main(int argc, const char *argv[]) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    KdpMember *me = [[KdpMember alloc] initWithId:@"KDPMember:KL5UQ4f48673352"
                                             role:@"Member"
                                           points:1];

    out(@"=== KDP Forum Profile ===");
    out([NSString stringWithFormat:@"Nickname : %@", [me memberId]]);
    out([NSString stringWithFormat:@"Code     : %@", [me shortCode]]);
    out([NSString stringWithFormat:@"Role     : %@", [me role]]);
    out([NSString stringWithFormat:@"Points   : %d", [me points]]);

    [me release];
    [pool drain];
    return 0;
}
