//
//  MidiButton.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "MidiButton.h"
#import "SequencerView.h"

@interface MidiButton ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL mouseDownSEL;
@property (nonatomic) SEL mouseUpSEL;

@end

@implementation MidiButton

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

- (id)initWithKeyNumber:(NSInteger)keyNumber target:(id)target mouseDownSEL:(SEL)mouseDownSEL mouseUpSEL:(SEL)mouseUpSEL
{
    if (self = [super init]) {
        self.keyNumber = keyNumber;
        self.frequency = [self getFrequencyForKeyNumber:self.keyNumber];
        self.isWhiteKey = keyPattern[(keyNumber - BASE_KEY) % 12];
        self.keyName = keyNames[(keyNumber - BASE_KEY) % 12];
        
        [self setButtonType:NSMomentaryChangeButton];
        
        if (self.isWhiteKey) {
            // Make it a white key
            [self setImage:[NSImage imageNamed:@"whiteKey"]];
            [self setAlternateImage:[NSImage imageNamed:@"whiteKeyPressed"]];
            
        } else {
            // Make it a black key
            [self setImage:[NSImage imageNamed:@"blackKey"]];
            [self setAlternateImage:[NSImage imageNamed:@"blackKeyPressed"]];
            
        }
        
        // Don't border the button
        [self setBordered:NO];
        
        // Set the title of the button
        [self setTitle:[NSString stringWithFormat:@"%@%ld", self.keyName, ((self.keyNumber - 40)/12) + 4]];
        
        // initialize the grid array
        self.gridButtons = [[NSMutableArray alloc] init];
        
        self.target = target;
        self.mouseDownSEL = mouseDownSEL;
        self.mouseUpSEL = mouseUpSEL;
    }
    
    return self;
}

/*
 * If drums
 */
- (void)changeKeyNameTo:(NSString *)keyName
{
    [self setTitle:keyName];
}

/*
 * If ! drums
 */
- (void)changeKeyNameToDefault
{
    [self setTitle:[NSString stringWithFormat:@"%@%ld", self.keyName, ((self.keyNumber - 40)/12) + 4]];
}

-(void)mouseUp:(NSEvent *)theEvent
{
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.mouseUpSEL];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.mouseUpSEL);
    }
}

-(void)mouseDown:(NSEvent *)theEvent
{
 
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.mouseDownSEL];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.mouseDownSEL);
    }
    
    // call super which handles ui on the main thread, and then returns when mouse up is called. so we call mouseUp manually
    [super mouseDown:theEvent];
    [self mouseUp:theEvent];
}

- (float)getFrequencyForKeyNumber:(NSInteger)keyNumber
{
    return powf(powf(2, (1./12)), keyNumber - 49) * 440;
}

@end
