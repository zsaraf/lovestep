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

@property (nonatomic, strong) NSMutableArray *grid;
@property (nonatomic, weak) IBOutlet SequencerHeaderView *sequenceHeaderView;

@end
