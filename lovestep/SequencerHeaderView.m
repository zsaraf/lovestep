//
//  SequencerHeaderView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerHeaderView.h"

@interface SequencerHeaderView ()

@property (nonatomic, strong) NSArray *resolutionValues;
@property (nonatomic) NSInteger currentLengthValue;
@property (nonatomic) NSInteger currentResolutionIndex;
@property (nonatomic) NSPoint previousLocationChange;

@end

@implementation SequencerHeaderView

void (^handleMouseDrag)(NSEvent *);

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

-(void)mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouse down mothafuckas");
    NSPoint point = [self.superview convertPoint:[theEvent locationInWindow] fromView:nil];
            NSView *v = [self hitTest:point];
    
    self.previousLocationChange = point;
    if (v == self.resolutionField) {
        handleMouseDrag = ^(NSEvent *event){
            NSPoint newPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
            CGFloat absDiff = abs(newPoint.y - self.previousLocationChange.y);
            if (absDiff > 10) {
                int toAdd = (newPoint.y > self.previousLocationChange.y) ? 1 : -1;
                self.currentResolutionIndex += toAdd;
                if (self.currentResolutionIndex < 0)
                    self.currentResolutionIndex = 0;
                else if
                    (self.currentResolutionIndex >= self.resolutionValues.count) self.currentResolutionIndex = self.resolutionValues.count - 1;
                [self.resolutionField setStringValue:[NSString stringWithFormat:@"1/%d", [[self.resolutionValues objectAtIndex:self.currentResolutionIndex] intValue]]];
                [self.delegate sequenceResolutionDidChangeToResolution:1/[[self.resolutionValues objectAtIndex:self.currentResolutionIndex] floatValue]];
                self.previousLocationChange = newPoint;
            }
        };
    } else if (v == self.lengthField) {
        handleMouseDrag = ^(NSEvent *event){
            NSPoint newPoint = [self.superview convertPoint:[event locationInWindow] fromView:nil];
            CGFloat absDiff = abs(newPoint.y - self.previousLocationChange.y);
            if (absDiff > 5) {
                int toAdd = (newPoint.y > self.previousLocationChange.y) ? 1 : -1;
                self.currentLengthValue += toAdd;
                if (self.currentLengthValue < 8)
                    self.currentLengthValue = 8;
                else if
                    (self.currentLengthValue > 32) self.currentLengthValue = 32;
                [self.lengthField setStringValue:[NSString stringWithFormat:@"%ld", self.currentLengthValue]];
                [self.delegate sequenceResolutionDidChangeToLength:self.currentLengthValue];
                self.previousLocationChange = newPoint;
            }
        };
    }
}


-(void)mouseDragged:(NSEvent *)theEvent
{
    handleMouseDrag(theEvent);
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.resolutionValues = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1],
                                                        [NSNumber numberWithInt:2],
                                                        [NSNumber numberWithInt:4],
                                                        [NSNumber numberWithInt:8],
                                                        [NSNumber numberWithInt:16],
                                                        [NSNumber numberWithInt:32], nil];
    self.currentResolutionIndex = 2;
    self.currentLengthValue = 32;
}

@end
