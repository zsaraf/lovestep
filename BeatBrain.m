//
//  BeatBrain.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "BeatBrain.h"

@implementation BeatBrain

+(BeatBrainNote)noteForFrame:(NSInteger)frame inLoop:(Loop *)loop
{
    BeatBrainNote note;
    NSInteger totalFrames = (int)(loop.length * (1./(float)loop.resolution * 4) * ((float)1/BPM) * 60 * SAMPLE_RATE);
    NSInteger numFramesPerNote = totalFrames/loop.length;
    NSInteger currentRep = frame % totalFrames;
    note.frameInNote = currentRep % numFramesPerNote;
    note.note = currentRep / numFramesPerNote;
    return note;
}

+ (NSInteger)numFramesPerNoteInLoop:(Loop *)loop
{
    return (1./(float)loop.resolution * 4) * 1./BPM * 60 * SAMPLE_RATE;
}

@end
