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
@property (nonatomic) NSString *keyName;
@property (nonatomic, strong) NSMutableArray *gridButtons;

- (id)initKeyWithName:(NSString *)keyName WhiteColor:(BOOL)isWhite;

@end
