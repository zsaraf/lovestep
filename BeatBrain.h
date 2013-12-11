//
//  BeatBrain.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loop.h"

#define BPM 120
#define SAMPLE_RATE 44100

typedef struct {
    NSInteger note;
    NSInteger frameInNote;
} BeatBrainNote;

@interface BeatBrain : NSObject

+(BeatBrainNote)noteForFrame:(NSInteger)frame inLoop:(Loop *)loop;
+ (NSInteger)numFramesPerNoteInLoop:(Loop *)loop;

@end
