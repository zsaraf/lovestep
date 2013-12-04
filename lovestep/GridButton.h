//
//  GridButton.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MidiButton.h"
#import "SequencerView.h"

@interface GridButton : NSView

// The midi button which the grid is associated with
@property (nonatomic, strong) MidiButton *midiButton;

// Position in the grid
@property (nonatomic) int position;

// Whether or ont the button is on
@property (nonatomic) BOOL isOn;

// Whether or not the button is disabled
@property (nonatomic) BOOL isDisabled;

// The view that contains the button
@property (nonatomic, strong) SequencerView *sequencerView;

// Init method for grid button
- (id)initInPosition:(int)position withMidiButton:(MidiButton *)midiButton fromView:(NSView *)fromView;

// Set the grid in the off state
- (void)setOffState;

// Set the grid in the on state
- (void)setOnState;

// Add a disable state for the grid
- (void)setDisabledState;

// Set enabled state for the grid
- (void)setEnabledState;

@end
