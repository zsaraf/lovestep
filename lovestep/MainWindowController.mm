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

@interface MainWindowController()

@property (nonatomic, weak) MainWindow *mWindow;
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;
@property (nonatomic, assign) RingBuffer *ringBuffer;
@property (nonatomic) NSInteger counter;
@property (nonatomic, strong) Instrument *currentInstrument;

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
    
    NSLog(@"%@", self.mWindow.sequencerView);
    BeatBrain *bb = [[BeatBrain alloc] initWithBPM:120 sampleRate:self.audioManager.samplingRate noteLength:2. numNotes:32];
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         memset(data, 0, numFrames * numChannels * sizeof(float));
         
//         BeatBrainNote note = [bb noteForFrame:wself.counter];
//         NSLog(@"%ld %ld", (long)note.note, (long)note.frameInNote);
         // fill
         for( int i = 0; i < numFrames; i++ )
         {
            BeatBrainNote note = [bb noteForFrame:wself.counter];
             // generate signal
             //data[i*numChannels] = ::sin( 2 * M_PI * 880 * wself.counter / wself.audioManager.samplingRate);
             data[i*numChannels] = [wself.currentInstrument valueForFrameIndex:note.frameInNote atFrequency:440];
             // copy into other channels
             for( int j = 1; j < numChannels; j++ )
                 data[i*numChannels+j] = data[i*numChannels];
             // increment sample number
             wself.counter++;
         }
    }];
    
    [self.audioManager play];
    
}
@end
