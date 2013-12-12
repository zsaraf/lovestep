//
//  SequencerHeaderView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ChangeInstrumentView.h"

@protocol SequencerHeaderViewDelegate

-(void)sequenceResolutionDidChangeToResolution:(NSInteger)resolution;
-(void)sequenceResolutionDidChangeToLength:(NSInteger)length;

@end

@interface SequencerHeaderView : NSView <NSControlTextEditingDelegate, NSTextFieldDelegate>

@property (nonatomic, weak) id<SequencerHeaderViewDelegate> delegate;
@property (nonatomic, weak) IBOutlet NSTextField *nameField;
@property (nonatomic, weak) IBOutlet NSTextField *resolutionField;
@property (nonatomic, weak) IBOutlet NSTextField *lengthField;
@property (nonatomic, strong) ChangeInstrumentView *civ;

- (void)prepareForTakeoffWithTarget:(id)target selector:(SEL)selector;

@end
