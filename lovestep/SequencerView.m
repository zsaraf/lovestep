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
#define KEY_WIDTTH 75
#define BLACK_KEY 0
#define WHITE_KEY 1

static const int keyPattern[12] = {
    WHITE_KEY,
    BLACK_KEY,
    WHITE_KEY,
    BLACK_KEY,
    WHITE_KEY,
    WHITE_KEY,
    BLACK_KEY,
    WHITE_KEY,
    BLACK_KEY,
    WHITE_KEY,
    BLACK_KEY,
    WHITE_KEY,
};

- (id)initWithCoder:(NSCoder *)aDecoder
{
    NSLog(@"initWithCoder called in SequencerView...");
    if (self = [super initWithCoder:aDecoder]) {
        // Setup the document view
        self.docView = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.frame.size.width, KEY_HEIGHT * NUM_KEYS))];
        
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
- (void)drawKeys2
{
    NSLog(@"Drawing keys...");
    
    float currentY = 0.0f;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        BOOL isWhiteKey = keyPattern[i%12];
        if (i%12 == 12) {
            if (isWhiteKey) NSLog(@"isWhiteKey");
            else NSLog(@"isBlackKey");
        }
        
        MidiButton *newKey = [[MidiButton alloc] initKeyWithWhiteColor:isWhiteKey];
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, KEY_HEIGHT))];

        [self.docView addSubview:newKey];
        currentY += KEY_HEIGHT;
    }
    
    [self setDocumentView:self.docView];
}

@end