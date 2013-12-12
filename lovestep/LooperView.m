//
//  LooperView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LooperView.h"
#import "LooperHeaderView.h"

@interface LooperView ()

@property (nonatomic, weak) IBOutlet LooperHeaderView *looperHeaderView;
@property (nonatomic, weak) IBOutlet ActiveLoopsView *activeLoopsSrollView;
@property (nonatomic, weak) IBOutlet InactiveLoopsView *inactiveLoopsScrollView;
@property (nonatomic, strong) NSMutableArray *loops;

@end

@implementation LooperView

/*
 * Set the background color
 */
- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

/*
 * Init with frame
 */
- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        self.loops = [[NSMutableArray alloc] init];
    }
    
    return self;
}

/*
 * Awoke
 */
- (void)awakeFromNib
{
    self.activeLoopsSrollView.delegate = self;
    self.inactiveLoopsScrollView.delegate = self;
}

/*
 * From the loop delegate
 */
- (void)didFindNewLoop:(Loop *)newLoop
{
    [self.loops addObject:newLoop];
    [self.activeLoopsSrollView addLoop:newLoop];
}

/*
 * Make the loop active
 */
- (void)makeLoopActive:(Loop *)loop
{
    [self.activeLoopsSrollView addLoop:loop];
    [self.inactiveLoopsScrollView removeLoop:loop];
}

/*
 * Make the loop inactive
 */
- (void)makeLoopInactive:(Loop *)loop
{
    [self.activeLoopsSrollView removeLoop:loop];
    [self.inactiveLoopsScrollView addLoop:loop];
}

@end
