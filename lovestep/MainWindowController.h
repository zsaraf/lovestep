//
//  MainWindowController.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SequencerHeaderView.h"
#import "SequencerView.h"

@protocol NoteChangeDelegate

-(void)noteDidChangeToNoteNumber:(NSInteger)noteNumber;

@end

@interface MainWindowController : NSWindowController <SequencerViewDelegate>

@property (nonatomic, weak) id<NoteChangeDelegate> noteChangeDelegate;
@property (nonatomic, strong) NSMutableArray *loops;

@end
