//
//  GridButton.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "GridButton.h"

@interface GridButton ()

@property (nonatomic, strong) NSImageView *imageView;

@end

@implementation GridButton

/*
 * Custom init to set the vars
 */
- (id)initInPosition:(int)position withMidiButton:(MidiButton *)midiButton fromView:(NSView *)fromView
{
    if (self = [super init]) {
        
        // Setup all the vars
        self.position = position;
        self.midiButton = midiButton;
        self.isOn = false;
        self.sequencerView = (SequencerView *)fromView;
        
    }
    
    return self;
}

/*
 * Override set frame so we can place the image view
 */
- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    
    // Setup the image view
    self.imageView = [[NSImageView alloc] initWithFrame:CGRectMake(0, 0, frameRect.size.width, frameRect.size.height)];
    [self addSubview:self.imageView];
    
    // Set the grid to be in the off state
    [self setOffState];
}

/*
 * Sets the grid button in the off state
 */
- (void)setOffState
{
    [self.imageView.cell setImage:[NSImage imageNamed:@"gridButton"]];
    self.isOn = NO;
}

/*
 * Sets the grid button in the on state
 */
- (void)setOnState
{
    [self.imageView setImage:[NSImage imageNamed:@"gridButtonPressed"]];
    self.isOn = YES;
}

@end
