//
//  TickerView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/4/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "TickerView.h"

@implementation TickerView

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
