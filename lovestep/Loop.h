//
//  Loop.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FluidSynth/FluidSynth.h>

@interface Loop : NSObject

@property (nonatomic) fluid_synth_t *fluidSynth;
@property (nonatomic) NSInteger length;
@property (nonatomic) NSInteger resolution;
@property (nonatomic, strong) NSArray *grid;

@end
