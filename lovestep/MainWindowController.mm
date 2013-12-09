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
#import "SineWave.h"
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

// The loop currently in the sequencer view
@property (nonatomic, strong) Loop *currentLoop;

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
        self.currentLoop = [[Loop alloc] init];
        
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
    fluid_synth_bank_select(synth, 2, 120);
    fluid_synth_program_change(synth, 2, 24);
    fluid_synth_set_sample_rate(synth, 44100);
//    fluid_synth_noteon(synth, 2, 40, 100);
//    fluid_synth_noteon(synth, 2, 44, 100);
//    fluid_synth_noteon(synth, 2, 47, 100);
    float *lBuff = (float *)malloc(512 * sizeof(float));
    float *rBuff = (float *)malloc(512 * sizeof(float));
    /* Do useful things here */
    
//    delete_fluid_synth(synth);
//    delete_fluid_settings(settings);
    
    self.audioManager = [Novocaine audioManager];
    
    __weak MainWindowController * wself = self;

    self.counter = 0;
    
    self.bb = [[BeatBrain alloc] initWithBPM:120 sampleRate:self.audioManager.samplingRate noteLength:.25 numNotes:32];
    self.noteChangeDelegate = self.mWindow.sequencerView;
    self.mWindow.sequencerView.sequenceHeaderView.delegate = self;
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         // Clear out the buffer
         memset(data, 0, numFrames * numChannels * sizeof(float));
         
         BeatBrainNote note = [wself.bb noteForFrame:wself.counter];
         NSInteger noteLength = [wself.bb numFramesPerNote];
        
         CGFloat currentNoteLength;
         CGFloat nextNoteLength = 0;
         NSInteger gButtonIndex;
         
         if (noteLength - note.frameInNote < numFrames || note.frameInNote == 0)
         {
             if (note.frameInNote == 0) {
                 currentNoteLength = 0;
                 note.note = (note.note == 0) ? wself.bb.numNotes - 1 : note.note - 1;
             } else {
                 currentNoteLength = noteLength - note.frameInNote;
             }
             nextNoteLength = numFrames - currentNoteLength;
             gButtonIndex = (note.note >= wself.bb.numNotes - 1) ? 0 : note.note + 1;
             [wself.noteChangeDelegate noteDidChangeToNoteNumber:gButtonIndex];
         } else {
             currentNoteLength = numFrames;
         }
         
         wself.counter += numFrames;
         
         if (currentNoteLength != 0) {
             fluid_synth_write_float(synth, currentNoteLength, lBuff, 0, 1, rBuff, 0, 1);
         }
         if (nextNoteLength != 0) {
             for (int i = 0; i < wself.mWindow.sequencerView.grid.count; i++) {
                 NSMutableArray *arr = [wself.mWindow.sequencerView.grid objectAtIndex:i];
                 GridButton *gridButton = (GridButton *)[arr objectAtIndex:note.note];
                 if (gridButton.isOn) {
                     fluid_synth_noteoff(synth, 2, (int)gridButton.midiButton.keyNumber);
                 }
                 GridButton *nextGridButton = (GridButton *)[arr objectAtIndex:gButtonIndex];
                 if (nextGridButton.isOn) {
                     fluid_synth_noteon(synth, 2, (int)nextGridButton.midiButton.keyNumber, 100);
                 }
             }
             fluid_synth_write_float(synth, nextNoteLength, lBuff, currentNoteLength, 1, rBuff, currentNoteLength, 1);
         }
         
         for (int i = 0; i < numFrames; i++) {
             data[i * numChannels] = lBuff[i] * 2;
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
