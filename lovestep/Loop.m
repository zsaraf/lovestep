//
//  Loop.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Loop.h"

@interface Loop ()

@property (nonatomic) fluid_settings_t *fluidSettings;

@end

@implementation Loop
@synthesize instrument = _instrument;
@synthesize creator = _creator;

-(id)initWithInstrument:(Instrument *)instrument
              length:(NSInteger)length
          resolution:(NSInteger)resolution
                grid:(NSMutableArray *)grid
                name:(NSString *)name
             creator:(NSString *)creator
             enabled:(BOOL)enabled
              loopNo:(NSInteger)loopNo
{
    if (self = [super init]) {
        // inititalize fluid synth
        [self initFluidSynth];
        
        self.instrument = instrument;
        self.length = length;
        self.resolution = resolution;
        self.grid = grid;
        self.name = name;
        self.loopNo = loopNo;
        self.creator = (creator) ? creator : @"";
        self.enabled = enabled;
    }
    return self;
}

- (void)initFluidSynth
{
    self.fluidSettings = new_fluid_settings();
    fluid_settings_setint(self.fluidSettings, "synth.polyphony", 128);
    self.fluidSynth = new_fluid_synth(self.fluidSettings);
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SoundFont1" ofType:@"sf2"];
    
    int success = fluid_synth_sfload(self.fluidSynth, [bundlePath cStringUsingEncoding:NSUTF8StringEncoding], 1);
    if (!success) {
        NSAssert(0, @"Fluid synth could not load");
    }
    
    fluid_synth_set_sample_rate(self.fluidSynth, 44100);
}

-(void)setInstrument:(Instrument *)instrument
{
    _instrument = instrument;
    fluid_synth_bank_select(self.fluidSynth, 2, (int)instrument.bank);
    fluid_synth_program_change(self.fluidSynth, 2, (int)instrument.program);
}

-(void)dealloc
{
    delete_fluid_synth(self.fluidSynth);
    delete_fluid_settings(self.fluidSettings);
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.instrument forKey:@"instrument"];
    [encoder encodeInteger:self.length forKey:@"length"];
    [encoder encodeInteger:self.resolution forKey:@"resolution"];
    [encoder encodeObject:self.grid forKey:@"grid"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeBool:self.enabled forKey:@"enabled"];
    [encoder encodeObject:self.creator forKey:@"creator"];
    [encoder encodeInteger:self.loopNo forKey:@"loopNo"];
    NSLog(@"%@", self.creator);
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    Instrument *instrument = [decoder decodeObjectForKey:@"instrument"];
    NSInteger length = [decoder decodeIntegerForKey:@"length"];
    NSInteger resolution = [decoder decodeIntegerForKey:@"resolution"];
    NSMutableArray *grid = [decoder decodeObjectForKey:@"grid"];
    NSString *name = [decoder decodeObjectForKey:@"name"];
    BOOL enabled = [decoder decodeBoolForKey:@"enabled"];
    NSString *creator = [decoder decodeObjectForKey:@"creator"];
    NSInteger loopNo = [decoder decodeIntegerForKey:@"loopNo"];
    NSLog(@"%@", creator);
    
    return [self initWithInstrument:instrument length:length resolution:resolution grid:grid name:name creator:creator enabled:enabled loopNo:loopNo];
}

-(void)setCreator:(NSString *)creator
{
    _creator = creator;
    self.loopId = [NSString stringWithFormat:@"%@%ld", _creator, self.loopNo];
    NSLog(@"%@", self.loopId);
}

@end
