//
//  Loop.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FluidSynth/FluidSynth.h>
#import "Instrument.h"

@interface Loop : NSObject <NSCoding>

-(id)initWithInstrument:(Instrument *)instrument
              length:(NSInteger)length
          resolution:(NSInteger)resolution
                grid:(NSMutableArray *)grid
                name:(NSString *)name
             creator:(NSString *)creator
             enabled:(BOOL)enabled;

// Instrument used
@property (nonatomic) fluid_synth_t *fluidSynth;

@property (nonatomic, strong) Instrument *instrument;

// Length of the total loop
@property (nonatomic) NSInteger length;

// Resolution of each individual note
@property (nonatomic) NSInteger resolution;

// Actual loop grid (most important)
@property (nonatomic, strong) NSMutableArray *grid;

// Name of the creator
@property (nonatomic, strong) NSString *creator;

// Whether or not it is enabled
@property (nonatomic) BOOL enabled;

// Name of the loop
@property (nonatomic, strong) NSString *name;


@end
