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
}

@end
