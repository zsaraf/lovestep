//
//  SocketUtil.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SocketUtil.h"
#import "GCDAsyncSocket.h"

@interface SocketUtil ()

@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation SocketUtil

static SocketUtil *myInstance;

//singleton
+(SocketUtil *)instance
{
    @synchronized(self)
    {
        if (myInstance == NULL)
            myInstance = [[self alloc] init];
    }
    
    return(myInstance);
}

-(void)createConnection
{
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error;
    if (![self.socket connectToHost:@"10.31.78.119" onPort:80 error:&error]) {
        NSLog(@"something fucked up");
    }
}

-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"did connect to host");
    [sock readDataToLength:1000 withTimeout:10 tag:1];
}

-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"%@", data);
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"did disconnect");
}

@end
