//
//  Loop.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Loop.h"

@implementation Loop

-(id)initWithInstrument:(Instrument *)instrument
              length:(NSInteger)length
          resolution:(NSInteger)resolution
                grid:(NSMutableArray *)grid
                name:(NSString *)name
             enabled:(BOOL)enabled
{
    if (self = [super init]) {
        self.instrument = instrument;
        
        // inititalize fluid synth
        fluid_settings_t* settings = new_fluid_settings();
        fluid_settings_setint(settings, "synth.polyphony", 128);
        self.fluidSynth = new_fluid_synth(settings);
        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SoundFont1" ofType:@"sf2"];
        
        int success = fluid_synth_sfload(self.fluidSynth, [bundlePath cStringUsingEncoding:NSUTF8StringEncoding], 1);
        if (!success) {
            NSAssert(0, @"Fluid synth could not load");
        }
        fluid_synth_bank_select(self.fluidSynth, 2, (int)instrument.bank);
        fluid_synth_program_change(self.fluidSynth, 2, (int)instrument.program);
        fluid_synth_set_sample_rate(self.fluidSynth, 44100);
        self.length = length;
        self.resolution = resolution;
        self.grid = grid;
        self.name = name;
        self.enabled = enabled;
    }
    return self;
}
@end
