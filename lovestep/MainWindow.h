//
//  MainWindow.h
//  lovestep
//
//  Created by Raymond kennedy on 11/19/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SequencerView.h"
#import "LooperView.h"

@interface MainWindow : NSWindow

@property (nonatomic, weak) IBOutlet SequencerView *sequencerView;
@property (nonatomic, weak) IBOutlet LooperView *looperView;

@end
