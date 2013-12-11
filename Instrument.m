//
//  Instrument.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

-(id)initWithFluidSynthBank:(NSInteger)bank
                    program:(NSInteger)program
                volumeRatio:(CGFloat)volumeRatio
                       name:(NSString *)name;
{
    if (self = [super init]) {
        self.program = program;
        self.bank = bank;
        self.volumeRatio = volumeRatio;
        self.name = name;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.program = [aDecoder decodeIntegerForKey:@"program"];
        self.bank = [aDecoder decodeIntegerForKey:@"bank"];
        self.volumeRatio = [aDecoder decodeFloatForKey:@"volumeRatio"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

+(Instrument *)defaultInstrument
{
    return [[Instrument alloc] initWithFluidSynthBank:0 program:1 volumeRatio:1 name:@"Grand Piano"];
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.program forKey:@"program"];
    [aCoder encodeInteger:self.bank forKey:@"bank"];
    [aCoder encodeFloat:self.volumeRatio forKey:@"volumeRatio"];
}



@end
