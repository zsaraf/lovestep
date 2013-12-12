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
        self.loop = loop;
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:.4f green:.4f blue:.6f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
