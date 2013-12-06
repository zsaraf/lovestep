//
//  SequencerView.h
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainWindowController.h"

@interface SequencerView : NSView <NoteChangeDelegate>

// Two dimensional grid of gridbuttons
@property (nonatomic, strong) NSMutableArray *grid;

// Controls the sequenceHeaderView
@property (nonatomic, weak) IBOutlet SequencerHeaderView *sequenceHeaderView;

// Called from the sequence header view when the length changes
- (void)lengthDidChange:(NSInteger)newLength;

@end
