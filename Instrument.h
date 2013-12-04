//
//  Instrument.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject

-(id)initWithSamplingRate:(CGFloat)samplingRate;
-(CGFloat)valueForFrameIndex:(NSInteger)frameIndex  atFrequency:(NSInteger)frequency;
-(void)fillDataArrayBeginningAtFrameIndex:(NSInteger)frameIndex atFrequency:(NSInteger)frequency length:(NSInteger)length;

@property (nonatomic) CGFloat samplingRate;

@end
