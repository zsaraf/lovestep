//
//  MidiButton.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "MidiButton.h"

@implementation MidiButton

- (id)initKeyWithName:(NSString *)keyName WhiteColor:(BOOL)isWhite
{
    self = [super init];
    if (self) {
        self.isWhiteKey = isWhite;
        self.keyName = keyName;
        
        if (self.isWhiteKey) {
            // Make it a white key
            [self setImage:[NSImage imageNamed:@"whiteKey"]];
            
        } else {
            // Make it a black key
            [self setImage:[NSImage imageNamed:@"blackKey"]];
        }
        [self setBordered:NO];
        
    }
    return self;
}

@end
