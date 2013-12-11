//
//  SequencerHeaderView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerHeaderView.h"
#import "SequencerView.h"
#import "ChangeInstrumentView.h"

@interface SequencerHeaderView ()

@property (nonatomic, strong) NSArray *resolutionValues;
@property (nonatomic) NSInteger currentLengthValue;
@property (nonatomic) NSInteger currentResolutionIndex;
@property (nonatomic) NSPoint previousLocationChange;
@property (nonatomic, weak) IBOutlet NSButton *changeInstrumentButton;
@property (nonatomic, strong) ChangeInstrumentView *civ;

@end

@implementation SequencerHeaderView

// The width and the height of the change instrument view
#define CHANGE_INSTRUMENT_VIEW_WIDTH 200
#define CHANGE_INSTRUMENT_VIEW_HEIGHT 400

void (^handleMouseDrag)(NSEvent *);

/*
 * Sets up the background for the view
 */
- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

/*
 * On mouse down event
 */
- (void)mouseDown:(NSEvent *)theEvent
{
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
                [self.delegate sequenceResolutionDidChangeToResolution:[[self.resolutionValues objectAtIndex:self.currentResolutionIndex] integerValue]];
                
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
    } else {
        handleMouseDrag = nil;
    }
}

/*
 * When the instrument is changed
 */
- (IBAction)changeInstrumentButtonPressed:(id)sender
{
    NSLog(@"Called");
    if ([self.civ isHidden]) {
        [self.civ setHidden:NO];
    } else {
        [self.civ setHidden:YES];
    }
}

/*
 * Called on mouse drag
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
    if (handleMouseDrag) handleMouseDrag(theEvent);
}

/*
 * Initialize contents
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setWantsLayer:YES];
    
    self.resolutionValues = [[NSArray alloc] initWithObjects:
                                                        [NSNumber numberWithInteger:4],
                                                        [NSNumber numberWithInteger:8],
                                                        [NSNumber numberWithInteger:16],
                                                        [NSNumber numberWithInteger:32], nil];
    self.currentResolutionIndex = 0;
    self.currentLengthValue = 32;
    
    // Remove the highlights
    [self.changeInstrumentButton.cell setHighlightsBy:NSImageCellType];
    
    // Setup the change instrument view
    self.civ = [[ChangeInstrumentView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(self.superview.frame.size.width - CHANGE_INSTRUMENT_VIEW_WIDTH, self.superview.frame.size.height - self.frame.size.height - CHANGE_INSTRUMENT_VIEW_HEIGHT, CHANGE_INSTRUMENT_VIEW_WIDTH, CHANGE_INSTRUMENT_VIEW_HEIGHT))];
    
    [self.civ setHidden:YES];
    
    self.civ.delegate = (id<ChangeInstrumentDelegate>)self.superview;

    // Add it to subview
    [self.superview addSubview:self.civ];
}

@end
