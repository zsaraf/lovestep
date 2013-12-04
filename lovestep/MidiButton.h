//
//  MidiButton.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define BASE_KEY 40

@interface MidiButton : NSButton

@property (nonatomic) BOOL isWhiteKey;
@property (nonatomic) NSString *keyName;
@property (nonatomic, strong) NSMutableArray *gridButtons;
@property (nonatomic) float frequency;
@property (nonatomic) NSInteger keyNumber;

- (id)initWithKeyNumber:(NSInteger)keyNumber;

@end
