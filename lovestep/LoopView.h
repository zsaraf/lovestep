//
//  LoopView.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Loop.h"
#import "RSVerticallyCenteredTextFieldCell.h"

@interface LoopView : NSView

- (id)initWithFrame:(NSRect)frame andLoop:(Loop *)loop target:(id)target selector:(SEL)selector;

@property (nonatomic, strong) Loop *loop;
@property (nonatomic, strong) NSTextField *nameTextField;
@property (nonatomic, strong) NSTextField *creatorTextField;
@property (nonatomic, strong) NSTextField *resolutionTextField;
@property (nonatomic, strong) NSTextField *lengthTextField;

@end
