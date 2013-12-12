//
//  DividerView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/12/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "DividerView.h"

@implementation DividerView

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.3f green:.3f blue:.3f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

@end
