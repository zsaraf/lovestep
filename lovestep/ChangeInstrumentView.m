//
//  ChangeInstrumentView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "ChangeInstrumentView.h"

@implementation ChangeInstrumentView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        
        
        [self setAlphaValue:0.6f];
    }
    
    return self;
}

/*
 * Black bg
 */
- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}


@end
