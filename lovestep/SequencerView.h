//
//  SequencerView.h
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SequencerViewDelegate.h"
#import "NoteChangeDelegate.h"
#import "Loop.h"
#import "ChangeInstrumentView.h"
#import "SequencerHeaderView.h"
#import "MidiButton.h"

@interface SequencerView : NSView <SequencerHeaderViewDelegate, ChangeInstrumentDelegate, NoteChangeDelegate>

// Controls the sequenceHeaderView
@property (nonatomic, weak) IBOutlet SequencerHeaderView *sequenceHeaderView;

// The current loop
@property (nonatomic, strong) Loop *currentLoop;

// fluid synth responsible for button presses
@property (nonatomic) fluid_synth_t *keyboardFluidSynth;
@property (nonatomic) fluid_settings_t *keyboardFluidSettings;

// Delegate
@property (nonatomic, weak) id <SequencerViewDelegate>delegate;

// Called from the sequence header view when the length changes
- (NSInteger)keyNumberForIndex:(NSInteger)index;

-(void)midiButtonEnabled:(MidiButton *)midiButton;
-(void)midiButtonDisabled:(MidiButton *)midiButton;

@end
