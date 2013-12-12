//
//  LoopView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Loop.h"

@interface LoopView : NSView

- (id)initWithFrame:(NSRect)frame andLoop:(Loop *)loop;

@property (nonatomic, strong) Loop *loop;

@end
