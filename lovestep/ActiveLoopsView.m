//
//  ActiveLoopsView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "ActiveLoopsView.h"
#import "LoopView.h"

@interface ActiveLoopsView ()

@property (nonatomic, strong) NSMutableArray *loops;
@property (nonatomic, strong) NSView *docView;
@property (nonatomic, strong) NSMutableArray *loopViews;

@end

@implementation ActiveLoopsView

#define LOOP_SIZE 122
#define SPACING 8
#define LOOPS_PER_ROW 4

/*
 * Init with coder
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.loops = [[NSMutableArray alloc] init];
        self.docView = [[NSView alloc] initWithFrame:self.bounds];
        self.loopViews = [[NSMutableArray alloc] init];
        
        [self setDocumentView:self.docView];
        
    }
    return self;
}

/*
 * Add the loop to the array
 */
- (void)addLoop:(Loop *)loop
{
    [self.loops addObject:loop];
    [self updateUI];
}

/*
 * Remove the loop from the array
 */
- (void)removeLoop:(Loop *)loop
{
    [self.loops removeObject:loop];
    [self updateUI];
}

/*
 * Redraws the UI for the scrollview
 */
- (void)updateUI
{
    // Remove all the loop subviews and redraw them
    for (int i = 0; i < self.loopViews.count; i++) {
        [[self.loopViews objectAtIndex:i] removeFromSuperview];
    }
    
    // Update the size of the document view
    float height = ((((self.loops.count - 1) / 4) + 1) * (LOOP_SIZE + (SPACING ))) + SPACING;
    
    [self.docView setFrame:NSMakeRect(0, 0, self.frame.size.width, MAX(self.frame.size.height, height))];
    
    float currentX = SPACING;
    float currentY = MAX(self.frame.size.height, height) - (LOOP_SIZE + SPACING);
    for (int i = 0; i < self.loops.count; i++) {
        
        // Create a new loop view
        LoopView *newLoopView = [[LoopView alloc] initWithFrame:NSMakeRect(currentX, currentY, LOOP_SIZE, LOOP_SIZE) andLoop:[self.loops objectAtIndex:i] target:self selector:@selector(loopHit:)];

        [self.loopViews addObject:newLoopView];
        [self.docView addSubview:newLoopView];
        
        if ((i + 1) % 4 == 0) {
            currentX = SPACING;
            currentY -= (LOOP_SIZE + SPACING);
        } else {
            currentX += (LOOP_SIZE + SPACING);
        }
    }
    
    [self setDocumentView:self.docView];
}

/*
 * Called when one of the loops is hit
 */
- (void)loopHit:(id)sender
{
    [self.delegate makeLoopInactive:((LoopView *)sender).loop];
}

@end
