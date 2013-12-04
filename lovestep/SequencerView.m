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
#import "TickerView.h"

#import <QuartzCore/QuartzCore.h>

@interface SequencerView ()

typedef struct Resolution {
    int nominator;
    int denominator;
} Resolution;

@property (nonatomic) int length;
@property (nonatomic) Resolution resolution;
@property (nonatomic, strong) NSMutableArray *midiButtons;

@property (nonatomic) BOOL addGrid;
@property (nonatomic) BOOL subtractGrid;

@property (nonatomic, strong) TickerView *ticker;

@end

@implementation SequencerView

#define NUM_KEYS 25

#define KEY_WIDTTH 50
#define CELL_LENGTH 25
#define HEADER_HEIGHT 62

#define DEFAULT_LENGTH 32

/*
 * Draws the keys and the grid and inits the frame
 */
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
        [self setupTicker];
    }
    return self;
}

/*
 * Sets up the ticker
 */
- (void)setupTicker
{
    self.ticker = [[TickerView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(KEY_WIDTTH, 0, CELL_LENGTH, self.frame.size.height - HEADER_HEIGHT))];
    [self.ticker setAlphaValue:0.2f];
    
    // Set the background color just as a test
    
    [self addSubview:self.ticker];
}

/*
 * Draws all the midi keys
 */
- (void)drawKeys
{
    float currentY = 0.0f;
    float yInc = CELL_LENGTH;
    int currentKeyNumber = BASE_KEY;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        MidiButton *newKey = [[MidiButton alloc] initWithKeyNumber:currentKeyNumber];
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, CELL_LENGTH))];
        
        [self addSubview:newKey];
        [self.midiButtons addObject:newKey];
        
        currentKeyNumber++;
        
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

/*
 * Finds the row for a given touch
 */
- (int)rowForTouch:(NSPoint)touch
{
    
    return touch.y/CELL_LENGTH;
}

/*
 * Finds the col for a given touch
 */
- (int)colForTouch:(NSPoint)touch
{
    return (touch.x - KEY_WIDTTH)/ CELL_LENGTH;
}

/*
 * Called when the mouse goes down
 */
- (void)mouseDown:(NSEvent *)theEvent
{
    // Get the row/col from the spot
    NSPoint locInWindow = [theEvent locationInWindow];
    NSPoint loc = [self convertPoint:locInWindow fromView:nil];
    
    int row = [self rowForTouch:loc];
    int col = [self colForTouch:loc];
    
    // Get the grid button at the row and col
    GridButton *gb = [[self.grid objectAtIndex:row] objectAtIndex:col];
    
    // Do the appropriate thing to it
    if (gb.isOn) {
        [gb setOffState];
        self.subtractGrid = YES;
    } else {
        [gb setOnState];
        self.addGrid = YES;
    }
}

/*
 * Called while the mouse is draggin
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
    
    if (self.subtractGrid || self.addGrid) {
        
        // Get the row/col from the spot
        NSPoint locInWindow = [theEvent locationInWindow];
        NSPoint loc = [self convertPoint:locInWindow fromView:nil];
        
        int row = [self rowForTouch:loc];
        int col = [self colForTouch:loc];
        
        // Get the grid button at the row and col
        GridButton *gb = [[self.grid objectAtIndex:row] objectAtIndex:col];
        
        if (self.subtractGrid) {
            [gb setOffState];
        } else {
            [gb setOnState];
        }
    }
}

/*
 * Called when the mouse is up
 */
- (void)mouseUp:(NSEvent *)theEvent
{
    self.subtractGrid = NO;
    self.addGrid = NO;
}

/*
 * Highlights the column
 */
- (void)highlightColumn:(NSInteger)columnNumber
{
    [self.ticker setFrame:NSRectFromCGRect(CGRectMake(KEY_WIDTTH + columnNumber * (CELL_LENGTH), self.ticker.frame.origin.y, self.ticker.frame.size.width, self.ticker.frame.size.height))];
}

/*
 * Delegate method -- highlight all gridbuttons in the col
 */
- (void)noteDidChangeToNoteNumber:(NSInteger)noteNumber
{
    [self highlightColumn:noteNumber];
}

@end
