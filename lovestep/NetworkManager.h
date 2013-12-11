//
//  NetworkManager.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/13/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "Loop.h"

@protocol NetworkManagerDelegate

@optional
-(void)networkManagerDidFindNetworkService:(BOOL)found;
-(void)networkManagerReceivedNewLoop:(Loop *)loop;

@end

@interface NetworkManager : NSObject <GCDAsyncSocketDelegate>

-(void)createNetwork;
-(void)sendLoop:(Loop *)loop;
+(NetworkManager *)instance;


@property (nonatomic, weak) id<NetworkManagerDelegate> delegate;

@end
