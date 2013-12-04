//
//  SequencerView.m
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerView.h"
#import "SequencerHeaderView.h"
#import "MidiButton.h"
#import "GridButton.h"

#import <QuartzCore/QuartzCore.h>

@interface SequencerView ()

typedef struct Resolution {
    int nominator;
    int denominator;
} Resolution;

@property (nonatomic, weak) IBOutlet SequencerHeaderView *sequenceHeaderView;

@property (nonatomic) int length;
@property (nonatomic) Resolution resolution;
@property (nonatomic, strong) NSMutableArray *midiButtons;

@end

@implementation SequencerView

#define NUM_KEYS 25

#define KEY_WIDTTH 50
#define CELL_LENGTH 25
#define HEADER_HEIGHT 62

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
        self.grid = [[NSMutableArray alloc] init];
        
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
    float yInc = CELL_LENGTH;
    NSInteger currentFreq = 100.0f;

    for (int i = 0; i < NUM_KEYS; i++) {
        BOOL isWhiteKey = keyPattern[i%12];
        NSString *keyName = keyNames[i%12];
        
        MidiButton *newKey = [[MidiButton alloc] initKeyWithName:keyName WhiteColor:isWhiteKey frequency:currentFreq];
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, CELL_LENGTH))];
        [newKey setTitle:[NSString stringWithFormat:@"%@%d", keyName, (i/12) + 1]];
    
        [self addSubview:newKey];
        [self.midiButtons addObject:newKey];
        
        currentFreq += 25;
        
        currentY += yInc;
    }

}

/*
 * Draws the grid
 */
- (void)drawGrid
{
    float currentY = 0.0f;
    
    float yInc = CELL_LENGTH;
    float xInc = CELL_LENGTH;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        float currentX = KEY_WIDTTH;
        
        NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:DEFAULT_LENGTH];
        
        for (int j = 0; j < DEFAULT_LENGTH; j++) {
            MidiButton *currentKey = [self.midiButtons objectAtIndex:i];
            GridButton *newButton = [[GridButton alloc] initInPosition:j withMidiButton:currentKey fromView:self];
            [newButton setFrame:NSRectFromCGRect(CGRectMake(currentX, currentY, CELL_LENGTH, CELL_LENGTH))];
            
            [currentKey.gridButtons addObject:newButton];
            [newArray addObject:newButton];
            
            [self addSubview:newButton];
            
            currentX += xInc;
        }
        
        [self.grid addObject:newArray];
        
        currentY += yInc;
    }
}

@end
