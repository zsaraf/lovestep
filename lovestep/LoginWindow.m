//
//  LoginWindow.m
//  lovestep
//
//  Created by Raymond Kennedy on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoginWindow.h"

@interface LoginWindow()

@property (nonatomic, weak) IBOutlet NSTextField *usernameField;

@end

@implementation LoginWindow

@synthesize usernameField = _usernameField;

- (NSSize)windowWillResize:(NSWindow *) window toSize:(NSSize)newSize
{
	return [window frame].size; //no change
}


@end
