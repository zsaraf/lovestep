//
//  InactiveLoopsView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/5/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "InactiveLoopsView.h"

@interface InactiveLoopsView ()

@property (nonatomic, strong) NSMutableArray *loops;

@end

@implementation InactiveLoopsView

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

@end
