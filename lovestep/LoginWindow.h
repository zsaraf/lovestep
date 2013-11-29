//
//  LoginWindow.h
//  lovestep
//
//  Created by Raymond Kennedy on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NetworkManager.h"
#import "MainWindow.h"
#import "AppDelegate.h"

@interface LoginWindow : NSWindow <NSControlTextEditingDelegate, NetworkManagerDelegate>

@end
