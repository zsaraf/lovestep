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
#import "NetworkManager.h"

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
        self.pendingLoops = [[NSMutableArray alloc] init];
        
        self.mWindow.sequencerView.delegate = self;
        
        [self setupNovocaine];
    }
    
    return self;
}

/*
 * Sequencer view delegate method
 */
- (void)sequencerViewDidPushLoop:(Loop *)newLoop
{
    @synchronized(self.mWindow.sequencerView.currentLoop) {
        [self.loops addObject:newLoop];
        self.mWindow.sequencerView.currentLoop = nil;
    }
    [self.loopDelegate didFindNewLoop:newLoop];
    [[NetworkManager instance] sendLoop:newLoop];
}

/*
 * Network manager enable loop with id
 */
- (void)networkManagerDisableLoopWithId:(NSString *)loopId
{
    [self.loopDelegate disableLoopWithId:loopId];
}

/*
 * Network manager disable loop with id
 */
- (void)networkManagerEnableLoopWithId:(NSString *)loopId
{
    [self.loopDelegate enableLoopWithId:loopId];
}

/*
 * Network manager delegate method
 */
-(void)networkManagerReceivedNewLoop:(Loop *)loop
{
    [self.loopDelegate didFindNewLoop:loop];
    [self.pendingLoops addObject:loop];
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
    if (!loop.enabled) return;
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
            [self.noteChangeDelegate noteDidChangeToNoteNumber:gButtonIndex];
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
        mainData[i * numChannels] += lData[i] * loop.instrument.volumeRatio * 5;
    }
}

-(void)checkPendingLoopsWithNumFrames:(NSInteger)numFrames
{
    NSMutableArray *discardedItems = [NSMutableArray array];
    for (Loop *loop in self.pendingLoops) {
        BeatBrainNote note = [BeatBrain noteForFrame:self.counter inLoop:loop];
        NSInteger noteLength = [BeatBrain numFramesPerNoteInLoop:loop];
        if (note.note == 0 || (note.note == loop.length - 1 && noteLength - note.frameInNote < numFrames)) {
            [discardedItems addObject:loop];
        }
    }
    [self.pendingLoops removeObjectsInArray:discardedItems];
    [self.loops addObjectsFromArray:discardedItems];
}

// Adds data from keyboard Synth (located in sequencerView) to the mainData
-(void)addKeyboardSynthWithlBuff:(float *)lBuff
                           rBuff:(float *)rBuff
                        mainData:(float *)mainData
                       numFrames:(NSInteger)numFrames
                     numChannels:(NSInteger)numChannels
{
    fluid_synth_write_float(self.mWindow.sequencerView.keyboardFluidSynth, (int)numFrames, lBuff, 0, 1, rBuff, 0, 1);
    for (int i = 0; i < numFrames; i++) {
        mainData[i * numChannels] += lBuff[i] * self.mWindow.sequencerView.currentLoop.instrument.volumeRatio * 5;
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
    
    float *lBuff = (float *)malloc(512 * sizeof(float));
    float *rBuff = (float *)malloc(512 * sizeof(float));
    
    self.audioManager = [Novocaine audioManager];
    
    __weak MainWindowController * wself = self;
    
    self.counter = 0;
    
    self.noteChangeDelegate = self.mWindow.sequencerView;
    self.loopDelegate = self.mWindow.looperView;
    
    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         // Clear out the buffer
         memset(data, 0, numFrames * numChannels * sizeof(float));
         [wself checkPendingLoopsWithNumFrames:numFrames];
         
         @synchronized(wself.mWindow.sequencerView.currentLoop) {
             if (wself.mWindow.sequencerView.currentLoop) {
                 [wself soundDataForLoop:wself.mWindow.sequencerView.currentLoop numFrames:numFrames numChannels:numChannels lData:lBuff rData:rBuff mainData:data];
             }
             for (Loop *loop in wself.loops) {
                 [wself soundDataForLoop:loop numFrames:numFrames numChannels:numChannels lData:lBuff rData:rBuff mainData:data];
             }
         }
         
         // add data from the synth controlled by keyboard buttons
         [wself addKeyboardSynthWithlBuff:lBuff rBuff:rBuff mainData:data numFrames:numFrames numChannels:numChannels];
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
