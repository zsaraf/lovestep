//
//  NoteChangeDelegate.h
//  lovestep
//
//  Created by Raymond Kennedy on 12/10/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#ifndef lovestep_NoteChangeDelegate_h
#define lovestep_NoteChangeDelegate_h

@class MainWindowController;

@protocol NoteChangeDelegate

-(void)noteDidChangeToNoteNumber:(NSInteger)noteNumber;

@end

#endif
