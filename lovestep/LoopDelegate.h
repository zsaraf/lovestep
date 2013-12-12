//
//  LoopDelegate.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#ifndef lovestep_LoopDelegate_h
#define lovestep_LoopDelegate_h

@class MainWindowController, Loop;

@protocol LoopDelegate

- (void)didFindNewLoop:(Loop *)newLoop;
- (void)didSilenceLoopWithId:(NSString *)loopId;

@end

#endif
