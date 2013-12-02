//
//  MidiButton.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MidiButton : NSButton

@property (nonatomic) BOOL isWhiteKey;

- (id)initKeyWithWhiteColor:(BOOL)isWhite;

@end
