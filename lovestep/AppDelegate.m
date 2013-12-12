//
//  AppDelegate.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkManager.h"
#import "MainWindow.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    // Insert code here to initialize your application
    [self.loginWindow makeKeyAndOrderFront:nil];
    [self.mainWindow orderOut:self];
    
    // REMOVE for final version
    //[[NSUserDefaults standardUserDefaults] setValue:@"zach" forKey:@"username"];
    //[self didLogIn];
}

- (void)didLogIn
{
    [self.loginWindow orderOut:self];
    self.wc = [[MainWindowController alloc] initWithWindow:self.mainWindow];
    [self.mainWindow makeKeyAndOrderFront:nil];
    ((MainWindow *)self.mainWindow).sequencerView.currentLoop.creator = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    [NetworkManager instance].delegate = self.wc;
}

@end
