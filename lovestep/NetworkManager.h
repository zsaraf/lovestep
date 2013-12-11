//
//  NetworkManager.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/13/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol NetworkManagerDelegate

-(void)networkManagerDidFindNetworkService:(BOOL)found;

@end

@interface NetworkManager : NSObject <NSNetServiceDelegate, NSNetServiceBrowserDelegate, GCDAsyncSocketDelegate>

-(void)publishNetwork;
-(void)searchForNetwork;
+(NetworkManager *)instance;


@property (nonatomic, weak) id<NetworkManagerDelegate> delegate;

@end
