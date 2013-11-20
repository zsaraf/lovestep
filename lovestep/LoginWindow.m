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
@property (nonatomic, weak) IBOutlet NSTextField *promptField;
@property (nonatomic) BOOL hasFirstUsername;

@end

@implementation LoginWindow

@synthesize usernameField = _usernameField;
@synthesize promptField = _promptField;
@synthesize hasFirstUsername = _hasFirstUsername;

/*
 * So that the user can't resize the login window
 */
- (NSSize)windowWillResize:(NSWindow *) window toSize:(NSSize)newSize
{
    NSLog(@"Called");
	return [window frame].size; //no change
}

/*
 * Called when the user hits enter in the text field
 */
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
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
- (void)saveUsername
{
    if (!self.hasFirstUsername) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"username"];
        [self.usernameField setStringValue:@""];
        self.hasFirstUsername = YES;
        [self.promptField setStringValue:@"Enter your partner's username:"];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"partnerUsername"];
        [NetworkManager instance].delegate = self;
        [[NetworkManager instance] searchForNetwork];
        [self setSearchingUI];
    }
}

/*
 * Searching for connection update in UI
 */
- (void)setSearchingUI
{
    [self.usernameField setHidden:YES];
    [self.promptField setStringValue:@"Searching for connection..."];
}

/*
 * Delegate method from the network manager
 */
-(void)networkManagerDidFindNetworkService:(BOOL)found
{
    if (!found) {
        [[NetworkManager instance] publishNetwork];
        [self.promptField setStringValue:@"Hosting connection - waiting for others..."];
    } else {
        
        // We have the two services connected -- set them up
        
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
