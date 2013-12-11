//
//  Loop.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "Loop.h"

@implementation Loop


-(id)initWithProgram:(NSInteger)program
                bank:(NSInteger)bank
              length:(NSInteger)length
          resolution:(NSInteger)resolution
                grid:(NSArray *)grid
                name:(NSString *)name
             enabled:(BOOL)enabled
{
    if (self = [super init]) {
        self.program = program;
        self.bank = bank;
        self.length = length;
        self.resolution = resolution;
        self.grid = grid;
        self.name = name;
        self.enabled = enabled;
    }
    return self;
}

@end
