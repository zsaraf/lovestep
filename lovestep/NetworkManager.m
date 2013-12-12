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
#define RECEIVED_DISABLE 25
#define RECEIVED_ENABLE 26


#define LOOP_TYPE 1
#define ENABLE_TYPE 2
#define DISABLE_TYPE 3

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
        
        if (header.type_id == LOOP_TYPE) {
            [self.asyncSocket readDataToLength:header.size withTimeout:-1 tag:RECEIVED_ARRAY];
        } else if (header.type_id == DISABLE_TYPE) {
            [self.asyncSocket readDataToLength:header.size withTimeout:-1 tag:RECEIVED_DISABLE];
        } else if (header.type_id == ENABLE_TYPE) {
            [self.asyncSocket readDataToLength:header.size withTimeout:-1 tag:RECEIVED_ENABLE];
        }
        
    } else if (tag == RECEIVED_ARRAY) {
        
        Loop *loop = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if ([(NSObject *)self.delegate respondsToSelector:@selector(networkManagerReceivedNewLoop:)]) {
            [self.delegate networkManagerReceivedNewLoop:loop];
        }
        
        [self.asyncSocket readDataToLength:sizeof(header_t) withTimeout:-1 tag:HEADER_TAG];
        
    } else if (tag == RECEIVED_DISABLE) {
        
        NSString *loopId = [NSString stringWithUTF8String:[data bytes]];
        [self.delegate networkManagerDisableLoopWithId:loopId];
        
        [self.asyncSocket readDataToLength:sizeof(header_t) withTimeout:-1 tag:HEADER_TAG];
    } else if (tag == RECEIVED_ENABLE) {
        
        NSString *loopId = [NSString stringWithUTF8String:[data bytes]];
        [self.delegate networkManagerEnableLoopWithId:loopId];
        [self.asyncSocket readDataToLength:sizeof(header_t) withTimeout:-1 tag:HEADER_TAG];
    }
}

- (void)didDisableLoopWithIdentifier:(NSString *)loopId
{
    NSData *data = [loopId dataUsingEncoding:NSUTF8StringEncoding];
    
    header_t header;
    header.type_id = DISABLE_TYPE;
    header.size = data.length;
    
    NSData *headData = [NSData dataWithBytes:&header length:sizeof(header)];
    
    [self.asyncSocket writeData:headData withTimeout:-1 tag:HEADER_TAG];
    [self.asyncSocket writeData:data withTimeout:-1 tag:RECEIVED_DISABLE];
}

- (void)didEnableLoopWithIdentifier:(NSString *)loopId
{
    NSData *data = [loopId dataUsingEncoding:NSUTF8StringEncoding];
    
    header_t header;
    header.type_id = ENABLE_TYPE;
    header.size = data.length;
    
    NSData *headData = [NSData dataWithBytes:&header length:sizeof(header)];
    
    [self.asyncSocket writeData:headData withTimeout:-1 tag:HEADER_TAG];
    [self.asyncSocket writeData:data withTimeout:-1 tag:RECEIVED_ENABLE];
}

@end
