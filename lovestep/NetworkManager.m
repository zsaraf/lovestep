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
    [self.asyncSocket readDataWithTimeout:20 tag:WAITING_FOR_OTHER_USER_TAG];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (tag == WAITING_FOR_OTHER_USER_TAG) {
        NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
        [self.delegate networkManagerDidFindNetworkService:YES];
        NSData *data = [[[NSUserDefaults standardUserDefaults] valueForKey:@"username"] dataUsingEncoding:NSUTF8StringEncoding];
        [self.asyncSocket writeData:data
                        withTimeout:3
                                tag:USER_NAME_SEND_TAG];
        [self.asyncSocket readDataWithTimeout:4 tag:USER_NAME_RECEIVE_TAG];
    } else if (tag == USER_NAME_RECEIVE_TAG) {
        NSLog(@"%@", [NSString stringWithUTF8String:[data bytes]]);
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
