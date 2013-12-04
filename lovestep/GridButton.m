//
//  GridButton.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "GridButton.h"

@implementation GridButton

- (id)initInPosition:(int)position withMidiButton:(MidiButton *)midiButton
{
    if (self = [super init]) {
        
        // Setup all the vars
        self.position = position;
        self.midiButton = midiButton;
        self.isOn = false;
        
        // Set the button type
        [self setButtonType:NSToggleButton];
        
        // Set the image
        [self setImage:[NSImage imageNamed:@"gridButton"]];
        [self setAlternateImage:[NSImage imageNamed:@"gridButtonOn"]];
        
        // Set whether or not it is bordered
        [self setBordered:NO];
        
        // Set when the grid button is pressed
        [self setTarget:self];
        [self setAction:@selector(gridButtonPressed)];
        
    }
    
    return self;
}

- (void)gridButtonPressed
{
    self.isOn = YES;
}

@end
