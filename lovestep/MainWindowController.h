//
//  MainWindowController.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "SequencerViewDelegate.h"
#import "NoteChangeDelegate.h"
#import "SequencerHeaderView.h"

@interface MainWindowController : NSWindowController <SequencerViewDelegate>

@property (nonatomic, weak) id<NoteChangeDelegate> noteChangeDelegate;
@property (nonatomic, strong) NSMutableArray *loops;

@end
