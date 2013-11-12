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
@property (nonatomic, weak) IBOutlet NSButton *continueButton;
@property (nonatomic) BOOL hasFirstUsername;

@end

@implementation LoginWindow

@synthesize usernameField = _usernameField;
@synthesize promptField = _promptField;
@synthesize continueButton = _continueButton;
@synthesize hasFirstUsername = _hasFirstUsername;

- (NSSize)windowWillResize:(NSWindow *) window toSize:(NSSize)newSize
{
	return [window frame].size; //no change
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if ([[self.usernameField stringValue] isEqualToString:@""] || !self.usernameField) {
        [self.usernameField setStringValue:@""];
    }
    
    [self saveUsername];
    
    return YES;
}

- (void)saveUsername {
    if (!self.hasFirstUsername) {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"username"];
        [self.continueButton setTitle:@"Finish"];
        [self.usernameField setStringValue:@""];
        self.hasFirstUsername = YES;
        [self setupForPartner];
    } else {
        [[NSUserDefaults standardUserDefaults] setValue:[self.usernameField stringValue] forKey:@"partnerUsername"];
        
        // CONNECT THE SOCKET BITCH
    }
}

- (IBAction)buttonPressed:(NSButton *)sender
{
    [self saveUsername];
}

- (void)setupForPartner {
    [self.promptField setStringValue:@"Enter your partner's username:"];
    
}

@end
