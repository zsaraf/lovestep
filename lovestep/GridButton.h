//
//  GridButton.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MidiButton.h"

@interface GridButton : NSButton

// The midi button which the grid is associated with
@property (nonatomic, strong) MidiButton *midiButton;

// Position in the grid
@property (nonatomic) int position;

// Whether or ont the button is on
@property (nonatomic) BOOL isOn;

// Init method for grid button
- (id)initInPosition:(int)position withMidiButton:(MidiButton *)midiButton;

@end