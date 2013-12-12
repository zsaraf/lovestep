//
//  LoopView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoopView.h"
#import "Loop.h"

@interface LoopView ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation LoopView

- (id)initWithFrame:(NSRect)frame andLoop:(Loop *)loop target:(id)target selector:(SEL)selector
{
    if (self = [super initWithFrame:frame]) {
        self.loop = loop;
        self.target = target;
        self.selector = selector;
        
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [[NSColor colorWithCalibratedRed:.4f green:.4f blue:.6f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.selector);
    }
}

@end
