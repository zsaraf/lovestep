//
//  LooperHeaderView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LooperHeaderView.h"

@implementation LooperHeaderView

- (void)drawRect:(NSRect)dirtyRect
{
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.75f green:.75f blue:.75f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
