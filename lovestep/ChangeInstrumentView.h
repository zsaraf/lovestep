//
//  ChangeInstrumentView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol ChangeInstrumentDelegate

@required

- (void)instrumentDidChangeToBank:(NSInteger)bank progNumber:(NSInteger)progNum;

@end

@interface ChangeInstrumentView : NSView <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, weak) id <ChangeInstrumentDelegate>delegate;

@end
