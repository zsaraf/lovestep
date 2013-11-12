//
//  SocketUtil.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@interface SocketUtil : NSObject<GCDAsyncSocketDelegate>

+(SocketUtil *)instance;
-(void)createConnection;

@end
