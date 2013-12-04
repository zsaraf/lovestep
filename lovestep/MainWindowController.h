//
//  MainWindowController.h
//  lovestep
//
//  Created by Zachary Waleed Saraf on 12/1/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol NoteChangeDelegate

-(void)noteDidChangeToNoteNumber:(NSInteger)noteNumber;

@end

@interface MainWindowController : NSWindowController

@property (nonatomic, weak) id<NoteChangeDelegate> noteChangeDelegate;

@end
