//
//  AppDelegate.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *loginWindow;
@property (nonatomic, weak) IBOutlet NSWindow *mainWindow;

- (void)didLogIn;

@end
