//
//  SequencerView.m
//  lovestep
//
//  Created by Raymond kennedy on 11/29/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "SequencerView.h"
#import "SequencerHeaderView.h"
#import "MidiButton.h"
#import "GridButton.h"
#import "TickerView.h"

#import <QuartzCore/QuartzCore.h>

@interface SequencerView ()

typedef struct Resolution {
    int nominator;
    int denominator;
} Resolution;

@property (nonatomic) int length;
@property (nonatomic) Resolution resolution;

@property (nonatomic, strong) NSMutableArray *midiButtons;
@property (nonatomic, strong) NSMutableArray *grid;

@property (nonatomic) BOOL addGrid;
@property (nonatomic) BOOL subtractGrid;

@property (nonatomic, strong) TickerView *ticker;
@property (nonatomic) NSInteger loopNo;

@property (nonatomic, strong) NSScrollView *scrollView;
@property (nonatomic, strong) NSView *docView;

@property (nonatomic) NSInteger currentNote;
@property (nonatomic, strong) NSArray *drumKits;

@end

@implementation SequencerView

#define NUM_KEYS 49

#define KEY_WIDTTH 50
#define CELL_LENGTH 25
#define HEADER_HEIGHT 62

#define MAX_LENGTH 32
#define DEFAULT_LENGTH 32
#define DEFAULT_RESOLUTION 16

/*
 * Draws the keys and the grid and inits the frame
 */
- (id)initWithFrame:(NSRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.midiButtons = [[NSMutableArray alloc] init];
        
        Instrument *instrument = [Instrument defaultInstrument];
        self.currentLoop = [[Loop alloc] initWithInstrument:instrument
                                                     length:DEFAULT_LENGTH
                                                 resolution:DEFAULT_RESOLUTION
                                                       grid:[[NSMutableArray alloc] init]
                                                       name:@"Loop1"
                                                    creator:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
                                                    enabled:YES
                                                     loopNo:self.loopNo];
        [self initializeKeyboardFluidSynths];
        self.grid = [[NSMutableArray alloc] init];
        
        // INitialize the document view and scroll view
        self.docView = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, NUM_KEYS * CELL_LENGTH)];
        self.scrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(0, 0, self.frame.size.width, self.frame.size.height - HEADER_HEIGHT)];
        
        [self addSubview:self.scrollView];
        [self.scrollView setHasVerticalScroller:YES];
        [self.scrollView setVerticalScrollElasticity:NSScrollElasticityNone];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.001f target:self selector:@selector(highlightColumn) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        
        [self parseDrumFile];
        
        // Initialization code here.
        // Draw the sequencer here
        [self drawKeys];
        [self drawGrid];
        [self setupTicker];
    }
    return self;
}

-(void)parseDrumFile
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DrumKit" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    self.drumKits = [content componentsSeparatedByString:@"\n"];
}

-(void)initializeKeyboardFluidSynths
{
    self.keyboardFluidSettings = new_fluid_settings();
    fluid_settings_setint(self.keyboardFluidSettings, "synth.polyphony", 128);
    self.keyboardFluidSynth = new_fluid_synth(self.keyboardFluidSettings);
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:@"SoundFont1" ofType:@"sf2"];
    
    int success = fluid_synth_sfload(self.keyboardFluidSynth, [bundlePath cStringUsingEncoding:NSUTF8StringEncoding], 1);
    if (!success) {
        NSAssert(0, @"Fluid synth could not load");
    }
    
    fluid_synth_set_sample_rate(self.keyboardFluidSynth, 44100);
    [self syncKeyboardFluidSynthWithCurrentLoop];
}

-(void)awakeFromNib
{
    // Setup the delegate
    self.sequenceHeaderView.delegate = self;
}

/*
 * Sets up the ticker
 */
- (void)setupTicker
{
    self.ticker = [[TickerView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(KEY_WIDTTH, 0, CELL_LENGTH, self.frame.size.height - HEADER_HEIGHT))];
    [self.ticker setAlphaValue:0.2f];
    
    // Set the background color just as a test
    
    [self addSubview:self.ticker];
}

/*
 * Draws all the midi keys
 */
- (void)drawKeys
{
    float currentY = 0.0f;
    float yInc = CELL_LENGTH;
    int currentKeyNumber = BASE_KEY;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        MidiButton *newKey = [[MidiButton alloc] initWithKeyNumber:currentKeyNumber target:self mouseDownSEL:@selector(midiButtonEnabled:) mouseUpSEL:@selector(midiButtonDisabled:)];
        
        [newKey setFrame:NSRectFromCGRect(CGRectMake(0.0f, currentY, KEY_WIDTTH, CELL_LENGTH))];
        
        [self.docView addSubview:newKey];
        [self.midiButtons addObject:newKey];
        
        currentKeyNumber++;
        
        currentY += yInc;
    }
    
}

/*
 * Draws the grid
 */
- (void)drawGrid
{
    float currentY = 0.0f;
    
    float yInc = CELL_LENGTH;
    float xInc = CELL_LENGTH;
    
    for (int i = 0; i < NUM_KEYS; i++) {
        
        float currentX = KEY_WIDTTH;
        
        NSMutableArray *loopGrid = [[NSMutableArray alloc] initWithCapacity:MAX_LENGTH];
        NSMutableArray *gridButtonGrid = [[NSMutableArray alloc] initWithCapacity:MAX_LENGTH];
        
        for (int j = 0; j < MAX_LENGTH; j++) {
            MidiButton *currentKey = [self.midiButtons objectAtIndex:i];
            GridButton *newButton = [[GridButton alloc] initInPosition:j withMidiButton:currentKey fromView:self];
            [newButton setFrame:NSRectFromCGRect(CGRectMake(currentX, currentY, CELL_LENGTH, CELL_LENGTH))];
            
            [currentKey.gridButtons addObject:newButton];
            [loopGrid addObject:[NSNumber numberWithBool:NO]];
            [gridButtonGrid addObject:newButton];
            
            [self.docView addSubview:newButton];
            
            currentX += xInc;
        }
        
        [self.scrollView setDocumentView:self.docView];
        
        [self.grid addObject:gridButtonGrid];
        [self.currentLoop.grid addObject:loopGrid];
        
        currentY += yInc;
    }
}

/*
 * Finds the row for a given touch
 */
- (int)rowForTouch:(NSPoint)touch
{
    float yAdjust = self.scrollView.documentVisibleRect.origin.y;
    return (touch.y + yAdjust)/CELL_LENGTH;
}

/*
 * Finds the col for a given touch
 */
- (int)colForTouch:(NSPoint)touch
{
    return (touch.x - KEY_WIDTTH)/ CELL_LENGTH;
}

/*
 * Called when the mouse goes down
 */
- (void)mouseDown:(NSEvent *)theEvent
{
    // Get the row/col from the spot
    NSPoint locInWindow = [theEvent locationInWindow];
    NSPoint loc = [self convertPoint:locInWindow fromView:nil];
    
    int row = [self rowForTouch:loc];
    int col = [self colForTouch:loc];
    
    GridButton *gb = [[self.grid objectAtIndex:row] objectAtIndex:col];
    
    // Do the appropriate thing to it
    if (gb.isOn) {
        [gb setOffState];
        [[self.currentLoop.grid objectAtIndex:row] setObject:[NSNumber numberWithBool:NO] atIndex:col] ;
        self.subtractGrid = YES;
    } else {
        [gb setOnState];
        [[self.currentLoop.grid objectAtIndex:row] setObject:[NSNumber numberWithBool:YES] atIndex:col] ;
        self.addGrid = YES;
    }
}

/*
 * Called while the mouse is draggin
 */
- (void)mouseDragged:(NSEvent *)theEvent
{
    
    if (self.subtractGrid || self.addGrid) {
        
        // Get the row/col from the spot
        NSPoint locInWindow = [theEvent locationInWindow];
        NSPoint loc = [self convertPoint:locInWindow fromView:nil];
        
        int row = [self rowForTouch:loc];
        int col = [self colForTouch:loc];
        
        if (row > NUM_KEYS - 1 || col > MAX_LENGTH - 1 || row < 0 || col < 0) return;
        
        // Get the grid button at the row and col
        GridButton *gb = [[self.grid objectAtIndex:row] objectAtIndex:col];
        
        if (self.subtractGrid) {
            [[self.currentLoop.grid objectAtIndex:row] setObject:[NSNumber numberWithBool:NO] atIndex:col] ;
            [gb setOffState];
        } else {
            [[self.currentLoop.grid objectAtIndex:row] setObject:[NSNumber numberWithBool:YES] atIndex:col] ;
            [gb setOnState];
        }
    }
}

/*
 * Called when the mouse is up
 */
- (void)mouseUp:(NSEvent *)theEvent
{
    self.subtractGrid = NO;
    self.addGrid = NO;
}

/*
 * Highlights the column
 */
- (void)highlightColumn
{
    [self.ticker setFrame:NSRectFromCGRect(CGRectMake(KEY_WIDTTH + self.currentNote * (CELL_LENGTH), self.ticker.frame.origin.y, self.ticker.frame.size.width, self.ticker.frame.size.height))];
}

/*
 * Delegate method -- highlight all gridbuttons in the col
 */
- (void)noteDidChangeToNoteNumber:(NSInteger)noteNumber
{
    self.currentNote = noteNumber;
}

/*
 * Send the loop
 */
-(void)keyDown:(NSEvent *)theEvent
{
    if (theEvent.keyCode == 36) {
        [self.sequenceHeaderView prepareForTakeoffWithTarget:self selector:@selector(sendLoopToMain:)];
    }
}

/*
 * Called once the user has chosen a name for the loop
 */
- (void)sendLoopToMain:(id)sender
{
    [self.currentLoop setName:self.sequenceHeaderView.nameField.stringValue];
    
    // Send it to the main
    [self.delegate sequencerViewDidPushLoop:self.currentLoop];
    
    // Clears the grid and resets information
    [self clearGrid];
}

/*
 * Allow for key down events
 */
- (BOOL)acceptsFirstResponder {
    return YES;
}

/*
 * Clears all the information and resets the current loop
 */
- (void)clearGrid
{
    self.currentLoop = [[Loop alloc] initWithInstrument:[Instrument defaultInstrument]
                                                 length:DEFAULT_LENGTH
                                             resolution:DEFAULT_RESOLUTION
                                                   grid:[[NSMutableArray alloc] init]
                                                   name:@"Loop1"
                                                creator:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]
                                                enabled:YES
                                                 loopNo:++self.loopNo];
    [self syncKeyboardFluidSynthWithCurrentLoop];
    
    // Clear the grid visually
    for (int i = 0; i < NUM_KEYS; i++) {
        
        NSMutableArray *loopGrid = [[NSMutableArray alloc] initWithCapacity:MAX_LENGTH];
        
        for (int j = 0; j < MAX_LENGTH; j++) {
            // Get the grid button at each place and set it to off
            GridButton *gb = [[self.grid objectAtIndex:i] objectAtIndex:j];
            [gb setOffState];
            [gb setEnabledState];
            
            [loopGrid addObject:[NSNumber numberWithBool:NO]];
        }
        
        [self.currentLoop.grid addObject:loopGrid];
        
    }
    
    // Set the defualt length and resolutions
    [self.sequenceHeaderView.lengthField setStringValue:[NSString stringWithFormat:@"%d", DEFAULT_LENGTH]];
    [self.sequenceHeaderView.resolutionField setStringValue:[NSString stringWithFormat:@"1/%d", DEFAULT_RESOLUTION]];
}

/*
 * Gets the key number at the given index
 */
- (NSInteger)keyNumberForIndex:(NSInteger)index
{
    GridButton *gb = [[self.grid objectAtIndex:index] objectAtIndex:0];
    return gb.midiButton.keyNumber;
}

/*
 * The resolution was updated
 */
- (void)sequenceResolutionDidChangeToResolution:(NSInteger)resolution
{
    // Update the current loop's resolution
    self.currentLoop.resolution = resolution;
}


/*
 * Length did cahnge to number
 */
- (void)sequenceResolutionDidChangeToLength:(NSInteger)length
{
    // Update the current loop's length
    [self.currentLoop setLength:length];
    
    for (int i = 0; i < [self.grid count]; i++) {
        
        for (NSInteger j = 0; j < length; j++) {
            
            // Get the gb
            GridButton *gb = [[self.grid objectAtIndex:i] objectAtIndex:j];
            [gb setEnabledState];
            
        }
        
        for (NSInteger j = length; j < MAX_LENGTH; j++) {
            // Get the gb
            GridButton *gb = [[self.grid objectAtIndex:i] objectAtIndex:j];
            [gb setDisabledState];
        }
    }
}

// sync the keyboard fluid synths instrument with that of the current loop.
// must be called whenever the currentLoops instrument changes
-(void)syncKeyboardFluidSynthWithCurrentLoop
{
    fluid_synth_bank_select(self.keyboardFluidSynth, 2, (int)self.currentLoop.instrument.bank);
    fluid_synth_program_change(self.keyboardFluidSynth, 2, (int)self.currentLoop.instrument.program);
}

-(void)instrumentDidChangeToInstrument:(Instrument *)instrument
{
    if ([instrument.name isEqualToString:@"Drums"]) {
        for (int i = 0; i < self.midiButtons.count; i++) {
            [[self.midiButtons objectAtIndex:i] changeKeyNameTo:[self.drumKits objectAtIndex:i]];
        }
    } else if ([self.currentLoop.instrument.name isEqualToString:@"Drums"]){
        for (int i = 0; i < self.midiButtons.count; i++) {
            [[self.midiButtons objectAtIndex:i] changeKeyNameToDefault];
        }
    }
    
    [self.currentLoop setInstrument:instrument];
    [self syncKeyboardFluidSynthWithCurrentLoop];
}

-(void)midiButtonEnabled:(MidiButton *)midiButton
{
    fluid_synth_noteon(self.keyboardFluidSynth, 2, (int)midiButton.keyNumber, 100);
}

-(void)midiButtonDisabled:(MidiButton *)midiButton
{
    fluid_synth_noteoff(self.keyboardFluidSynth, 2, (int)midiButton.keyNumber);
}

@end
