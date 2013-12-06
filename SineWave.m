//
//  SineWave.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SineWave.h"

@implementation SineWave

-(CGFloat)valueForFrameIndex:(NSInteger)frameIndex atFrequency:(NSInteger)frequency
{
    return sin( 2 * M_PI * frequency * frameIndex / self.samplingRate);
}

@end
