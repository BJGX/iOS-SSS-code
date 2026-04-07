//
//  FCSocket.m
//  ssrMac
//
//  Created by mac on 11/04/2023.
//  Copyright © 2023 ssrLive. All rights reserved.
//

#import "FCSocket.h"
#import <sys/socket.h>
 
#import <netinet/in.h>
 
#import <arpa/inet.h>

@interface FCSocket()
//@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic,assign)BOOL connected;


@end


@implementation FCSocket


+ (void)contact:(NSString *)addr2 port:(int)port block:(void(^)(NSString *string,NSInteger type))block {
   
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        char *ipadrr = [[self getIp:addr2] UTF8String];
            NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSInteger time = [date timeIntervalSince1970] * 1000;// *1000
        int clientSocket = socket(AF_INET, SOCK_STREAM, 0);
            if (clientSocket > 0) {
                NSLog(@"创建客户端Socket成功");
            }
        
        
        struct sockaddr_in addr;
        addr.sin_family = AF_INET;
        addr.sin_port = htons(80);
        addr.sin_addr.s_addr = inet_addr(ipadrr);

        int isConnected = connect(clientSocket, (const struct sockaddr *)&addr, sizeof(addr));
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isConnected == 0) {
                NSDate *date2 = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval time2 = [date2 timeIntervalSince1970] * 1000;// *1000
                NSInteger m = time2 - time;
                NSString *name = [NSString stringWithFormat:@"%ldms",m];
                NSInteger type = m < 500 ? 1 : 2;
                block(name,type);
                
            }
            else {
                block(@"延迟过大", 3);
            }
            
        });
    });
    
    
    
}

+ (NSString *)getIp:(NSString *)addr {
    CFHostRef hostRef = CFHostCreateWithName(kCFAllocatorDefault, (__bridge CFStringRef)addr);

    NSString *ip = @"";
    if (hostRef)
    {

        Boolean result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);

        if (result == TRUE)
        {
            NSArray *addresses = (__bridge NSArray*)CFHostGetAddressing(hostRef, &result);
            NSMutableArray * tempDNS = [[NSMutableArray alloc] init];
            for(int i = 0; i < addresses.count; i++)
            {
                struct sockaddr_in* remoteAddr;
                CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex((__bridge CFArrayRef)addresses, i);
                remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
                if(remoteAddr != NULL)
                {

                    const char *strIP41 = inet_ntoa(remoteAddr->sin_addr);
                    NSString *strDNS =[NSString stringWithCString:strIP41 encoding:NSASCIIStringEncoding];
//                    NSLog(@"RESOLVED %d:<%@>", i, strDNS);
                    ip = strDNS;
                    [tempDNS addObject:strDNS];

                }
            }
        }
    }
    return ip;

}


@end
