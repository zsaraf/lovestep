//
//  NetworkManager.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/13/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "NetworkManager.h"

#define WAITING_FOR_OTHER_USER_TAG 20
#define USER_NAME_SEND_TAG 21
#define USER_NAME_RECEIVE_TAG 22
#define RECEIVED_ARRAY 23
#define HEADER_TAG 24

#define LOOP_TYPE 1

@interface NetworkManager ()

@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@end

@implementation NetworkManager

static NetworkManager *myInstance;

//singleton
+(NetworkManager *)instance
{
    @synchronized(self)
    {
        if (myInstance == NULL)
            myInstance = [[self alloc] init];
    }
    
    return(myInstance);
}

-(void)createNetwork
{
    if (self.asyncSocket) return;
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    [self.asyncSocket connectToHost:@"10.31.78.119" onPort:80 error:nil];
    [self.asyncSocket readDataWithTimeout:-1 tag:WAITING_FOR_OTHER_USER_TAG];
}

-(void)sendLoop:(Loop *)loop
{
    NSData *loopData = [NSKeyedArchiver archivedDataWithRootObject:loop];
    NSLog(@"Sending loop with length: %ld", [loopData length]);
    if (loopData == nil) NSAssert(0, @"We are fucked couldnt archive this shit");
    
    header_t head;
    head.type_id = LOOP_TYPE;
    head.size = [loopData length];
    
    NSData *headData = [NSData dataWithBytes:&head length:sizeof(head)];
    
    [self.asyncSocket writeData:headData withTimeout:-1 tag:HEADER_TAG];
    [self.asyncSocket writeData:loopData withTimeout:-1 tag:RECEIVED_ARRAY];
}

#pragma delegate methods
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == WAITING_FOR_OTHER_USER_TAG) {
        
        NSLog(@"Found partner: %@", [NSString stringWithUTF8String:[data bytes]]);
        [self.delegate networkManagerDidFindNetworkService:YES];
        NSData *data = [[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] dataUsingEncoding:NSUTF8StringEncoding];
        [self.asyncSocket writeData:data withTimeout:20 tag:USER_NAME_SEND_TAG];
        [self.asyncSocket readDataWithTimeout:-1 tag:USER_NAME_RECEIVE_TAG];
        
    } else if (tag == USER_NAME_RECEIVE_TAG) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithUTF8String:[data bytes]] forKey:@"partner"];
        [self.asyncSocket readDataToLength:sizeof(header_t) withTimeout:-1 tag:HEADER_TAG];
        
    } else if (tag == HEADER_TAG) {
      
        header_t header;
        [data getBytes:&header length:sizeof(header_t)];
        
        [self.asyncSocket readDataToLength:header.size withTimeout:-1 tag:RECEIVED_ARRAY];
        
    } else if (tag == RECEIVED_ARRAY) {
        
        NSLog(@"%ld", data.length);
        NSLog(@"%@", [NSKeyedUnarchiver unarchiveObjectWithData:data]);
        Loop *loop = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([(NSObject *)self.delegate respondsToSelector:@selector(networkManagerReceivedNewLoop:)]) {
            [self.delegate networkManagerReceivedNewLoop:loop];
        }
        [self.asyncSocket readDataToLength:6077 withTimeout:-1 tag:RECEIVED_ARRAY];
        
    }
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{

}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"did acce[t new socket");
}

@end
