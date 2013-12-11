//
//  Instrument.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Instrument.h"

@implementation Instrument

-(id)initWithFluidSynthProgram:(NSInteger)program bank:(NSInteger)bank name:(NSString *)name
{
    if (self = [super init]) {
        self.program = program;
        self.bank = bank;
        self.name = name;
    }
    return self;
}

@end
