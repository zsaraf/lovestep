//
//  LoopView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoopView.h"
#import "Loop.h"

@implementation LoopView

- (id)initWithFrame:(NSRect)frame andLoop:(Loop *)loop
{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 10;
        self.loop = loop;
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = NSMakeRect([self bounds].origin.x + 3, [self bounds].origin.y + 3, [self bounds].size.width - 6, [self bounds].size.height - 6);
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10.0 yRadius:10.0];
    [path addClip];
    
    if ([self.loop.creator isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]) {
        [[NSColor colorWithDeviceRed:134/255. green:202/255. blue:254/255. alpha:1] set];
    } else {
        [[NSColor colorWithDeviceRed:162/255. green:134/255. blue:254/255. alpha:1] set];
    }
    NSRectFill(rect);
    [super drawRect:dirtyRect];
    [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1.] set];
    [path setLineWidth:5];
    [path stroke];
}

@end
