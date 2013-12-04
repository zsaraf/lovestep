//
//  SequencerHeaderView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerHeaderView.h"

@implementation SequencerHeaderView

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouse down mothafuckas");
    NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    NSPoint resolutionPoint = [self.resolutionField convertPoint:point fromView:self];
    NSLog(@"%f %f", resolutionPoint.x, resolutionPoint.y);
    
    NSPoint lengthPoint = [self.lengthField convertPoint:point fromView:self];
    NSLog(@"%f %f", lengthPoint.x, lengthPoint.y);
}

-(void)mouseDragged:(NSEvent *)theEvent
{
    
}

-(void)mouseUp:(NSEvent *)theEvent
{
    
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

@end
