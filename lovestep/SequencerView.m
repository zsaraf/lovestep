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

@property (nonatomic) int length;
@property (nonatomic) Resolution resolution;
@property (nonatomic, strong) NSMutableArray *midiButtons;

@end

@implementation SequencerView

#define NUM_KEYS 25

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

- (id)initWithFrame:(NSRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.midiButtons = [[NSMutableArray alloc] init];
        
        // Initialization code here.
        // Draw the sequencer here
        [self drawKeys];
        [self drawGrid];
        
    }
    return self;
}

/*
 * Draws all the midi keys
 */
- (void)drawKeys
{
    float currentY = 0.0f;
    float yInc = self.frame.size.height / NUM_KEYS;
    float keyHeight = yInc;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        BOOL isWhiteKey = keyPattern[i%12];
        NSString *keyName = keyNames[i%12];
        
        MidiButton *newKey = [[MidiButton alloc] initKeyWithName:keyName WhiteColor:isWhiteKey];
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, keyHeight))];
        [newKey setTitle:[NSString stringWithFormat:@"%@%d", keyName, (i/12) + 1]];
    
        [self addSubview:newKey];
        [self.midiButtons addObject:newKey];
        
        currentY += yInc;
    }
}

/*
 * Draws the grid
 */
- (void)drawGrid
{
    float currentY = 0.0f;
    
    float yInc = self.frame.size.height / NUM_KEYS;
    float xInc = (self.frame.size.width  - KEY_WIDTTH) / DEFAULT_LENGTH;
    
    float cellHeight = yInc;
    float cellWidth = xInc;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        float currentX = KEY_WIDTTH;
        
        for (int j = 0; j < DEFAULT_LENGTH; j++) {
            MidiButton *currentKey = [self.midiButtons objectAtIndex:i];
            GridButton *newButton = [[GridButton alloc] initInPosition:j withMidiButton:currentKey];
            [newButton setFrame:NSRectFromCGRect(CGRectMake(currentX, currentY, cellWidth, cellHeight))];
            
            [currentKey.gridButtons addObject:newButton];
            
            [self addSubview:newButton];
            
            currentX += xInc;
        }
        
        currentY += yInc;
    }
}

@end
