//
//  InactiveLoopsView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Loop.h"

@protocol InactiveLoopDelegate

- (void)makeLoopActive:(Loop *)loop;

@end

@interface InactiveLoopsView : NSScrollView

@property (nonatomic, weak) id <InactiveLoopDelegate>delegate;

- (void)addLoop:(Loop *)loop;
- (void)removeLoop:(Loop *)loop;

@end
