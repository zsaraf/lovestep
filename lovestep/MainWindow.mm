//
//  MainWindow.m
//  lovestep
//
//  Created by Raymond kennedy on 11/19/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "MainWindow.h"

#include <math.h>
#include <iostream>
#include <cstdlib>
#include <string.h>

using namespace std;

// our datetype
#define SAMPLE double
// corresponding format for RtAudio
#define MY_FORMAT RTAUDIO_FLOAT64
// sample rate
#define MY_SRATE 44100
// number of channels
#define MY_CHANNELS 2
// for convenience
#define MY_PIE 3.14159265358979

bool inputOn = false;

// global for frequency
SAMPLE g_freq = 440;
// globa sample number variable
SAMPLE g_t = 0;
// width provided by client
SAMPLE g_width = 0.9;

@interface MainWindow ()

@property (nonatomic, weak) IBOutlet SequencerView *sequencerView;

@end

@implementation MainWindow

int rtCallback( void * outputBuffer, void * inputBuffer, unsigned int numFrames,
               double streamTime, RtAudioStreamStatus status, void * data )
{
    // do a quick cout to see when it's being called
    cerr << ".";
    
    // cast!
    SAMPLE * outbutBuf = (SAMPLE *)outputBuffer;
    SAMPLE * inputBuf = (SAMPLE *)inputBuffer;
    
    // fill
    for( int i = 0; i < numFrames; i++ )
    {
        // generate signal
        float sig = ::sin( 2 * MY_PIE * g_freq * g_t / MY_SRATE );
        
        if (inputOn) sig *= inputBuf[i*MY_CHANNELS];
        
        outbutBuf[i*MY_CHANNELS] = sig;
        
        // copy into other channels
        for( int j = 1; j < MY_CHANNELS; j++ )
            outbutBuf[i*MY_CHANNELS+j] = outbutBuf[i*MY_CHANNELS];
        
        // increment sample number
        g_t += 1.0;
    }
    
    return 0;
}

- (void)awakeFromNib
{
    NSLog(@"Setting up the rtaudio shit");
    // instantiate RtAudio object
    RtAudio adac;
    // variables
    unsigned int bufferBytes = 0;
    // frame size
    unsigned int bufferFrames = 512;
    
    // check for audio devices
    if( adac.getDeviceCount() < 1 )
    {
        // nopes
        cout << "no audio devices found!" << endl;
        exit( 1 );
    }
    
    // let RtAudio print messages to stderr.
    adac.showWarnings( true );
    
    // set input and output parameters
    RtAudio::StreamParameters iParams, oParams;
    iParams.deviceId = adac.getDefaultInputDevice();
    iParams.nChannels = MY_CHANNELS;
    iParams.firstChannel = 0;
    oParams.deviceId = adac.getDefaultOutputDevice();
    oParams.nChannels = MY_CHANNELS;
    oParams.firstChannel = 0;
    
    // create stream options
    RtAudio::StreamOptions options;
    
    // go for it
    try {
        // open a stream
        adac.openStream( &oParams, &iParams, MY_FORMAT, MY_SRATE, &bufferFrames, &rtCallback, (void *)&bufferBytes, &options );
    }
    catch( RtError& e )
    {
        // error!
        cout << e.getMessage() << endl;
        exit( 1 );
    }
    
    // compute
    bufferBytes = bufferFrames * MY_CHANNELS * sizeof(SAMPLE);
    
    // test RtAudio functionality for reporting latency.
    cout << "stream latency: " << adac.getStreamLatency() << " frames" << endl;
    
    // go for it
    try {
        // start stream
        adac.startStream();
        
        // get input
        char input;
        std::cout << "running... press <enter> to quit (buffer frames: " << bufferFrames << ")" << endl;
        std::cin.get(input);
        
        // stop the stream.
        adac.stopStream();
    }
    catch( RtError& e )
    {
        // print error message
        cout << e.getMessage() << endl;
        goto cleanup;
    }
    
    cleanup:
    // close if open
    if( adac.isStreamOpen() )
        adac.closeStream();
}

@end
