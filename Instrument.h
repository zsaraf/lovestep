//
//  Instrument.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject <NSCoding>

-(id)initWithFluidSynthBank:(NSInteger)bank
                    program:(NSInteger)program
                volumeRatio:(CGFloat)volumeRatio
                       name:(NSString *)name;
+(Instrument *)defaultInstrument;

@property (nonatomic) NSInteger program;
@property (nonatomic) NSInteger bank;
@property (nonatomic) CGFloat volumeRatio;
@property (nonatomic, strong) NSString *name;


@end
