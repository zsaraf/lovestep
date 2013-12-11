//
//  Instrument.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Instrument : NSObject

-(id)initWithFluidSynthProgram:(NSInteger)program bank:(NSInteger)bank name:(NSString *)name;

@property (nonatomic) NSInteger program;
@property (nonatomic) NSInteger bank;
@property (nonatomic, strong) NSString *name;


@end
