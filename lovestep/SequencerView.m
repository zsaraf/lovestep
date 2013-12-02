//
//  SequencerView.m
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerView.h"
#import "MidiButton.h"
#import "GridButton.h"

#import <QuartzCore/QuartzCore.h>

@interface SequencerView ()

typedef struct Resolution {
    int nominator;
    int denominator;
} Resolution;

@property (nonatomic, strong) NSView *docView;
@property (nonatomic) int length;
@property (nonatomic) Resolution resolution;
@property (nonatomic, strong) NSMutableArray *midiButtons;

@end

@implementation SequencerView

#define NUM_KEYS 48

#define KEY_HEIGHT 50
#define KEY_WIDTTH 75

#define BLACK_KEY 0
#define WHITE_KEY 1

#define DEFAULT_LENGTH 32

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

static NSString *keyNames[12] = {
    @"C",
    @"C#",
    @"D",
    @"D#",
    @"E",
    @"F",
    @"F#",
    @"G",
    @"G#",
    @"A",
    @"A#",
    @"B"
};

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        // Setup the document view
        self.docView = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, (DEFAULT_LENGTH * KEY_HEIGHT) + KEY_WIDTTH, KEY_HEIGHT * NUM_KEYS))];
        
        self.midiButtons = [[NSMutableArray alloc] init];
        
        [self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
    
        // Initialization code here.
        // Draw the sequencer here
        [self drawKeys];
        [self drawGrid];
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
    float currentY = 0.0f;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        BOOL isWhiteKey = keyPattern[i%12];
        NSString *keyName = keyNames[i%12];
        
        MidiButton *newKey = [[MidiButton alloc] initKeyWithName:keyName WhiteColor:isWhiteKey];
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, KEY_HEIGHT))];
        [newKey setTitle:[NSString stringWithFormat:@"%@%d", keyName, (i/12) + 1]];
    
        [self.docView addSubview:newKey];
        [self.midiButtons addObject:newKey];
        
        currentY += KEY_HEIGHT;
    }
    
    [self setDocumentView:self.docView];
}

/*
 * Draws the grid
 */
- (void)drawGrid
{
    float currentY = 0.0f;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        float currentX = KEY_WIDTTH;
        
        for (int j = 0; j < DEFAULT_LENGTH; j++) {
            MidiButton *currentKey = [self.midiButtons objectAtIndex:i];
            GridButton *newButton = [[GridButton alloc] initInPosition:j withMidiButton:currentKey];
            [newButton setFrame:NSRectFromCGRect(CGRectMake(currentX, currentY, KEY_HEIGHT, KEY_HEIGHT))];
            
            [self.docView addSubview:newButton];
            
            currentX += KEY_HEIGHT;
        }
        currentY += KEY_HEIGHT;
    }
}

@end
