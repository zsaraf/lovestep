//
//  FuckApple.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/12/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "FuckApple.h"

@implementation FuckApple

-(id)initWithAppleCanSuckADick:(NSString *)aFatOne
{
    if (self = [super init]) {
        self.appleCanSuckADick = aFatOne;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.appleCanSuckADick = [aDecoder decodeObjectForKey:@"appleCanSuckADick"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.appleCanSuckADick forKey:@"appleCanSuckADick"];
}


@end
