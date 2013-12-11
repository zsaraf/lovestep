//
//  SequencerViewDelegate.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/10/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#ifndef lovestep_SequencerViewDelegate_h
#define lovestep_SequencerViewDelegate_h

@class SequencerView, Loop;

@protocol SequencerViewDelegate

- (void)sequencerViewDidPushLoop:(Loop *)newLoop;

@end


#endif
