//
//  SequencerView.m
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerView.h"

@interface SequencerView ()

@property (nonatomic, strong) NSView *docView;

@end

@implementation SequencerView

#define KEY_HEIGHT 50
#define NUM_KEYS 52

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder called in SequencerView...");
    if (self = [super initWithCoder:aDecoder]) {
        // Setup the document view
        self.docView = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.frame.size.width, KEY_HEIGHT * NUM_KEYS))];
        CALayer *viewLayer = [CALayer layer];
        [viewLayer setBackgroundColor:CGColorCreateGenericRGB(0.3, 0.5, 0.1, 1.0)]; //RGB plus Alpha Channel
        [self.docView setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
        [self.docView setLayer:viewLayer];
        
        [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        
        // Initialization code here.
        // Draw the sequencer here
        [self drawKeys];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

/*
 * Draws all the midi keys
 */
- (void)drawKeys
{
    NSLog(@"Drawing keys...");
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
    }
    
    [self setDocumentView:self.docView];
}

@end
