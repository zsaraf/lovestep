//
//  BeatBrain.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct {
    NSInteger note;
    NSInteger frameInNote;
} BeatBrainNote;

@interface BeatBrain : NSObject

-(id)initWithBPM:(NSInteger)bpm sampleRate:(NSInteger)sampleRate noteLength:(CGFloat)noteLength numNotes:(NSInteger)numNotes;
-(BeatBrainNote)noteForFrame:(NSInteger)frame;

@property (nonatomic) NSInteger bpm;
@property (nonatomic) NSInteger sampleRate;
@property (nonatomic) CGFloat noteLength;
@property (nonatomic) NSInteger numNotes;

@end
