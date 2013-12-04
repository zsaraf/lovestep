//
//  Instrument.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Instrument.h"

@interface Instrument ()

@property (nonatomic) CGFloat samplingRate;

@end

@implementation Instrument

-(id)initWithSamplingRate:(CGFloat)samplingRate
{
    if (self = [super init]) {
        self.samplingRate = samplingRate;
    }
    return self;
}

-(CGFloat)valueForFrameIndex:(NSInteger)frameIndex atFrequency:(NSInteger)frequency
{
    return 1.0;
}

@end
