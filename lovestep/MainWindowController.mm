//
//  MainWindowController.m
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "MainWindowController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "AudioFileWriter.h"
#import "MainWindow.h"
#import "BeatBrain.h"
#import "GridButton.h"
#import "Loop.h"

#import <FluidSynth/FluidSynth.h>

@interface MainWindowController()

// The main window
@property (nonatomic, weak) MainWindow *mWindow;

// Novacaine variables
@property (nonatomic, strong) Novocaine *audioManager;
@property (nonatomic, strong) AudioFileReader *fileReader;
@property (nonatomic, strong) AudioFileWriter *fileWriter;

// The number of frames happened
@property (nonatomic) NSInteger counter;

// The beat BRAIN yo
@property (nonatomic, strong) BeatBrain *bb;

// All the other loops from the looper
@property (nonatomic, strong) NSMutableArray *loops;

@end

@implementation MainWindowController

/*
 * Set up novocaine for audio playback
 */
-(id)initWithWindow:(NSWindow *)window
{
    if (self = [super initWithWindow:window]) {
        
        // Initialize the loops
        self.loops = [[NSMutableArray alloc] init];
        
        [self setupNovocaine];
    }
    
    return self;
}

/*
 * Returns the main window (actually)
 */
-(MainWindow *)mWindow
{
    return (MainWindow *)self.window;
}

-(void)soundDataForLoop:(Loop *)loop
              numFrames:(NSInteger)numFrames
            numChannels:(NSInteger)numChannels
                  lData:(float *)lData
                  rData:(float *)rData
               mainData:(float *)mainData
{
    BeatBrainNote note = [BeatBrain noteForFrame:self.counter inLoop:loop];
    NSInteger noteLength = [BeatBrain numFramesPerNoteInLoop:loop];
    
    CGFloat currentNoteLength;
    CGFloat nextNoteLength = 0;
    NSInteger gButtonIndex;
    
    if (noteLength - note.frameInNote < numFrames || note.frameInNote == 0)
    {
        if (note.frameInNote == 0) {
            currentNoteLength = 0;
            note.note = (note.note == 0) ? loop.length - 1 : note.note - 1;
        } else {
            currentNoteLength = noteLength - note.frameInNote;
        }
        nextNoteLength = numFrames - currentNoteLength;
        gButtonIndex = (note.note >= loop.length - 1) ? 0 : note.note + 1;
        
        if (loop == self.mWindow.sequencerView.currentLoop) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.noteChangeDelegate noteDidChangeToNoteNumber:gButtonIndex];
            });
        }
        
    } else {
        currentNoteLength = numFrames;
    }
    
    if (currentNoteLength != 0) {
        fluid_synth_write_float(loop.fluidSynth, currentNoteLength, lData, 0, 1, rData, 0, 1);
    }
    if (nextNoteLength != 0) {
        for (int i = 0; i < loop.grid.count; i++) {
            NSMutableArray *arr = [loop.grid objectAtIndex:i];
            bool isOn = [[arr objectAtIndex:note.note] boolValue];
            
            if (isOn) {
                fluid_synth_noteoff(loop.fluidSynth, 2, (int)[self.mWindow.sequencerView keyNumberForIndex:i]);
            }
            
            bool nextIsOn = [[arr objectAtIndex:gButtonIndex] boolValue];
            
            if (nextIsOn) {
                fluid_synth_noteon(loop.fluidSynth, 2, (int)[self.mWindow.sequencerView keyNumberForIndex:i], 100);
            }
        }
        fluid_synth_write_float(loop.fluidSynth, nextNoteLength, lData, currentNoteLength, 1, rData, currentNoteLength, 1);
    }
    
    for (int i = 0; i < numFrames; i++) {
        mainData[i * numChannels] += lData[i];
    }
}

/*
 * Sets up the audio playback
 */
-(void)setupNovocaine
{
    [super windowDidLoad];
    
    fluid_settings_t* settings = new_fluid_settings();
    fluid_settings_setint(settings, "synth.polyphony", 128);
    /* ... */
    fluid_synth_t *synth = new_fluid_synth(settings);
    
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SoundFont1" ofType:@"sf2"];
    
    int success = fluid_synth_sfload(synth, [bundlePath cStringUsingEncoding:NSUTF8StringEncoding], 1);
    if (!success) {
        NSAssert(0, @"Fluid synth could not load");
    }
    //fluid_synth_bank_select(synth, 2, 120);
    //fluid_synth_program_change(synth, 1, 1);
    //fluid_synth_set_sample_rate(synth, 44100);
    float *lBuff = (float *)malloc(512 * sizeof(float));
    float *rBuff = (float *)malloc(512 * sizeof(float));
    /* Do useful things here */
    
//    delete_fluid_synth(synth);
//    delete_fluid_settings(settings);
    
    self.audioManager = [Novocaine audioManager];
    
    __weak MainWindowController * wself = self;

    self.counter = 0;
    
    self.noteChangeDelegate = self.mWindow.sequencerView;
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         // Clear out the buffer
         memset(data, 0, numFrames * numChannels * sizeof(float));
         [wself soundDataForLoop:wself.mWindow.sequencerView.currentLoop numFrames:numFrames numChannels:numChannels lData:lBuff rData:rBuff mainData:data];
         for (Loop *loop in wself.loops) {
             [wself soundDataForLoop:loop numFrames:numFrames numChannels:numChannels lData:lBuff rData:rBuff mainData:data];
         }
         // increment time counter
         wself.counter += numFrames;
         
         for (int i = 0; i < numFrames; i++) {
             for (int j = 1; j < numChannels; j++) {
                 data[i * numChannels + j] = data[i * numChannels];
             }
         }
     }];
    
    [self.audioManager play];
}

@end
