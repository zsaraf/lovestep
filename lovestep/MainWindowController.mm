//
//  MainWindowController.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "MainWindowController.h"
#import "Novocaine.h"
#import "RingBuffer.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"
#import "MainWindow.h"
#import "BeatBrain.h"
#import "SineWave.h"
#import "GridButton.h"

@interface MainWindowController()

@property (nonatomic, weak) MainWindow *mWindow;
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;
@property (nonatomic, assign) RingBuffer *ringBuffer;
@property (nonatomic) NSInteger counter;
@property (nonatomic, strong) Instrument *currentInstrument;
@property (nonatomic, strong) BeatBrain *bb;

@end

@implementation MainWindowController

-(id)initWithWindow:(NSWindow *)window
{
    if (self = [super initWithWindow:window]) {
        [self setupNovocaine];
    }
    
    return self;
}

-(MainWindow *)mWindow
{
    return (MainWindow *)self.window;
}

-(void)setupNovocaine
{
    [super windowDidLoad];
    
    self.audioManager = [Novocaine audioManager];
    self.ringBuffer = new RingBuffer(32768, 2);
    
    __weak MainWindowController * wself = self;
    NSLog(@"%f", self.audioManager.samplingRate);
    self.counter =0;
    
    self.currentInstrument = [[SineWave alloc] initWithSamplingRate:self.audioManager.samplingRate];
    
    self.bb = [[BeatBrain alloc] initWithBPM:120 sampleRate:self.audioManager.samplingRate noteLength:.25 numNotes:32];
    self.noteChangeDelegate = self.mWindow.sequencerView;
    self.mWindow.sequencerView.sequenceHeaderView.delegate = self;
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         memset(data, 0, numFrames * numChannels * sizeof(float));
         BeatBrainNote note = [wself.bb noteForFrame:wself.counter];
         NSInteger noteLength = [wself.bb numFramesPerNote];
         
         CGFloat currentNoteLength;// = MIN(noteLength - note.frameInNote, numFrames);
         CGFloat nextNoteLength;
         NSInteger gButtonIndex;
         if (noteLength - note.frameInNote < numFrames) {
             currentNoteLength = noteLength - note.frameInNote;
             nextNoteLength = numFrames - currentNoteLength;
             gButtonIndex = (note.note >= wself.bb.numNotes - 1) ? 0 : note.note + 1;
             [wself.noteChangeDelegate noteDidChangeToNoteNumber:gButtonIndex];
         } else {
             currentNoteLength = numFrames;
             if (note.frameInNote == 0) [wself.noteChangeDelegate noteDidChangeToNoteNumber:note.note];
         }
         wself.counter += numFrames;
         for (int i = 0; i < wself.mWindow.sequencerView.grid.count; i++) {
             NSMutableArray *arr = [wself.mWindow.sequencerView.grid objectAtIndex:i];
             GridButton *gridButton = (GridButton *)[arr objectAtIndex:note.note];
             if (gridButton.isOn) {
                 
                 for (int j = 0; j < currentNoteLength; j++) {
                     data[j *numChannels] += [wself.currentInstrument valueForFrameIndex:note.frameInNote + j atFrequency:gridButton.midiButton.frequency];
                 }
             }
             
             if (nextNoteLength > 0) {
                 GridButton *nextGridButton = (GridButton *)[arr objectAtIndex:gButtonIndex];
                 if (nextGridButton.isOn) {
                     for (int j = 0; j < nextNoteLength; j++) {
                         NSInteger index = ((int)currentNoteLength + j) * numChannels;
                         data[index] += [wself.currentInstrument valueForFrameIndex:j atFrequency:nextGridButton.midiButton.frequency];
                     }
                 }
             }
         }
         for (int i = 0; i < numFrames; i++) {
             for (int j = 1; j < numChannels; j++) {
                 data[i * numChannels + j] = data[i * numChannels];
             }
         }
         
    }];
    
    [self.audioManager play];
}

-(void)sequenceResolutionDidChangeToResolution:(CGFloat)resolution
{
    [self.bb setNoteLength:resolution];
}

-(void)sequenceResolutionDidChangeToLength:(NSInteger)length
{
    [self.bb setNumNotes:length];
}

@end
