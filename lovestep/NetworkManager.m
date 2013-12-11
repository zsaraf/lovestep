//
//  NetworkManager.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/13/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "NetworkManager.h"

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
    [self.asyncSocket connectToHost:@"192.168.182.137" onPort:80 error:nil];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"did receive data %@", data);
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"did connect to host %@", host);
}

-(void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    NSLog(@"did acce[t new socket");
}

@end
