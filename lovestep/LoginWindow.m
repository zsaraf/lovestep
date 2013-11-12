//
//  LoginWindow.m
//  lovestep
//
//  Created by Raymond Kennedy on 11/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoginWindow.h"
#import "SocketUtil.h"

@interface LoginWindow()

@property (nonatomic, weak) IBOutlet NSTextField *usernameField;
@property (nonatomic, weak) IBOutlet NSTextField *promptField;
@property (nonatomic, weak) IBOutlet NSButton *continueButton;
@property (nonatomic) BOOL hasFirstUsername;

@end

@implementation LoginWindow

@synthesize usernameField = _usernameField;
@synthesize promptField = _promptField;
@synthesize continueButton = _continueButton;
@synthesize hasFirstUsername = _hasFirstUsername;

/*
 * So that the user can't resize the login window
 */
- (NSSize)windowWillResize:(NSWindow *) window toSize:(NSSize)newSize
{
	return [window frame].size; //no change
}

/*
 * Called when the user hits enter in the text field
 */
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if ([[self.usernameField stringValue] isEqualToString:@""] || !self.usernameField) {
        [self.usernameField setStringValue:@"Don't leave this shit empty"];
    } else {
        [self saveUsername];
    }
    return YES;
}

/*
 * Saves the username of the user or the partner
 */
- (void)saveUsername {
    if (!self.hasFirstUsername) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"username"];
        [self.continueButton setTitle:@"Finish"];
        [self.usernameField setStringValue:@""];
        self.hasFirstUsername = YES;
        [self.promptField setStringValue:@"Enter your partner's username:"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"partnerUsername"];
        NSLog(@"being called");
        [[SocketUtil instance] createConnection];
    }
}

/*
 * When the login button is pressed
 */
- (IBAction)buttonPressed:(NSButton *)sender
{
    [self saveUsername];
}

@end
