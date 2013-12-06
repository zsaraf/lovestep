//
//  BeatBrain.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/3/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "BeatBrain.h"

@implementation BeatBrain

- (id)initWithBPM:(NSInteger)bpm sampleRate:(NSInteger)sampleRate noteLength:(CGFloat)noteLength numNotes:(NSInteger)numNotes;
{
    if (self = [super init]) {
        self.bpm = bpm;
        self.sampleRate = sampleRate;
        self.noteLength = noteLength;
        self.numNotes = numNotes;
    }
    return self;
}

- (BeatBrainNote)noteForFrame:(NSInteger)frame
{
    BeatBrainNote note;
    NSInteger totalFrames = (int)(self.numNotes * self.noteLength * ((float)1/self.bpm) * 60 * self.sampleRate);
    NSInteger numFramesPerNote = totalFrames/self.numNotes;
    NSInteger currentRep = frame % totalFrames;
    note.frameInNote = currentRep % numFramesPerNote;
    note.note = currentRep / numFramesPerNote;
    return note;
}

- (NSInteger)numFramesPerNote
{
    return self.noteLength * 1./self.bpm * 60 * self.sampleRate;
}

@end
