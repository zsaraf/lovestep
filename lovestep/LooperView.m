//
//  LooperView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LooperView.h"
#import "LooperHeaderView.h"
#import "NetworkManager.h"
#import "AppDelegate.h"

@interface LooperView ()

@property (nonatomic, weak) IBOutlet LooperHeaderView *looperHeaderView;
@property (nonatomic, weak) IBOutlet ActiveLoopsView *activeLoopsSrollView;
@property (nonatomic, weak) IBOutlet InactiveLoopsView *inactiveLoopsScrollView;

@end

@implementation LooperView

/*
 * Set the background color
 */
- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [super drawRect:dirtyRect];
    [[NSColor colorWithCalibratedRed:.8f green:.8f blue:.8f alpha:1.0f] setFill];
    NSRectFill(dirtyRect);
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:NSInsetRect(self.bounds, -2.5, -2.5) xRadius:2 yRadius:2];
    [path setLineWidth:5];
    [[NSColor colorWithCalibratedRed:.5 green:.5 blue:.5 alpha:1.] set];
    [path stroke];
}

-(BOOL)wantsDefaultClipping
{
    return NO;
}

/*
 * Awoke
 */
- (void)awakeFromNib
{
    self.activeLoopsSrollView.delegate = self;
    self.inactiveLoopsScrollView.delegate = self;
    self.delegate = [NetworkManager instance];
}

/*
 * From the loop delegate
 */
- (void)didFindNewLoop:(Loop *)newLoop
{
    [self.activeLoopsSrollView addLoop:newLoop];
}

/*
 * Make the loop inactive
 */
- (void)disableLoopWithId:(NSString *)loopId
{
    NSArray *loops = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).wc.loops;
    for (Loop *loop in loops) {
        if ([loop.loopId isEqualToString:loopId]) {
            [loop setEnabled:NO];
            [self.activeLoopsSrollView removeLoop:loop];
            [self.inactiveLoopsScrollView addLoop:loop];
            return;
        }
    }
}

/*
 * Make the loop active
 */
- (void)enableLoopWithId:(NSString *)loopId
{
    NSArray *loops = ((AppDelegate *)[[NSApplication sharedApplication] delegate]).wc.loops;
    for (Loop *loop in loops) {
        if ([loop.loopId isEqualToString:loopId]) {
            [loop setEnabled:YES];
            [self.activeLoopsSrollView addLoop:loop];
            [self.inactiveLoopsScrollView removeLoop:loop];
            return;
        }
    }
}

/*
 * Make the loop active
 */
- (void)makeLoopActive:(Loop *)loop
{
    [self.delegate didEnableLoopWithIdentifier:loop.loopId];
    [loop setEnabled:YES];
    [self.activeLoopsSrollView addLoop:loop];
    [self.inactiveLoopsScrollView removeLoop:loop];
}

/*
 * Make the loop inactive
 */
- (void)makeLoopInactive:(Loop *)loop
{
    [self.delegate didDisableLoopWithIdentifier:loop.loopId];
    [loop setEnabled:NO];
    [self.activeLoopsSrollView removeLoop:loop];
    [self.inactiveLoopsScrollView addLoop:loop];
}

@end
