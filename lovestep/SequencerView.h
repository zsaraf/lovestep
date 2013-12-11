//
//  SequencerView.h
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "MainWindowController.h"
#import "Loop.h"
#import "ChangeInstrumentView.h"

@protocol SequencerViewDelegate

- (void)sequencerViewDidPushLoop:(Loop *)newLoop;

@end

@interface SequencerView : NSView <NoteChangeDelegate, SequencerHeaderViewDelegate, ChangeInstrumentDelegate>

// Controls the sequenceHeaderView
@property (nonatomic, weak) IBOutlet SequencerHeaderView *sequenceHeaderView;

// The current loop
@property (nonatomic, strong) Loop *currentLoop;

// Delegate
@property (nonatomic, strong) id <SequencerViewDelegate>delegate;

// Called from the sequence header view when the length changes
- (NSInteger)keyNumberForIndex:(NSInteger)index;

@end
