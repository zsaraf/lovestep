//
//  SequencerHeaderView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SequencerHeaderViewDelegate

-(void)sequenceResolutionDidChangeToResolution:(CGFloat)resolution;
-(void)sequenceResolutionDidChangeToLength:(NSInteger)length;

@end

@interface SequencerHeaderView : NSView

@property (nonatomic, weak) IBOutlet NSTextField *nameField;
@property (nonatomic, weak) IBOutlet NSTextField *resolutionField;
@property (nonatomic, weak) IBOutlet NSTextField *lengthField;
@property (nonatomic, weak) id<SequencerHeaderViewDelegate> delegate;

@end
