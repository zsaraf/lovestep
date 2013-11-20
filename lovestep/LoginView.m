//
//  LoginView.m
//  lovestep
//
//  Created by Raymond kennedy on 11/19/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

- (void)drawRect:(NSRect)dirtyRect {
    
    // set any NSColor for filling, say white:
    [[NSColor blackColor] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
