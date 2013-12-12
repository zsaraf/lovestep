//
//  LooperView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LoopDelegate.h"
#import "InactiveLoopsView.h"
#import "ActiveLoopsView.h"

@interface LooperView : NSView <LoopDelegate, InactiveLoopDelegate, ActiveLoopDelegate>

@end
