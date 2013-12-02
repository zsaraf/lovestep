//
//  AppDelegate.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.loginWindow makeKeyAndOrderFront:nil];
    [self.mainWindow orderOut:self];
    
    [self didLogIn];
}

- (void)didLogIn
{
    [self.loginWindow orderOut:self];
    [self.mainWindow makeKeyAndOrderFront:nil];
}

@end
