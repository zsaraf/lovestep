//
//  LoopView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/11/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "LoopView.h"
#import "Loop.h"

#define PADDING 15

@interface LoopView ()

@property (nonatomic, weak) id target;
@property (nonatomic) SEL selector;

@end

@implementation LoopView

- (id)initWithFrame:(NSRect)frame andLoop:(Loop *)loop target:(id)target selector:(SEL)selector
{
    if (self = [super initWithFrame:frame]) {
        self.loop = loop;
        self.target = target;
        self.selector = selector;
        
        CGFloat textFieldHeight = (self.frame.size.height - 2*PADDING) / 4;
        
        // create name text field
        self.nameTextField = [self initializeAndConfigureTextField];
        [self.nameTextField setStringValue:loop.name];
        [self addSubview:self.nameTextField];

        // create creator text field
        self.creatorTextField = [self initializeAndConfigureTextField];
        // offset rect by one times textfield height
        [self.creatorTextField setFrame:NSOffsetRect(self.creatorTextField.frame, 0, -1 *textFieldHeight)];
        [self.creatorTextField setStringValue:loop.creator];
        [self addSubview:self.creatorTextField];
    
        // create resolution text field
        self.resolutionTextField = [self initializeAndConfigureTextField];
        // offset rect by two times textfield height
        [self.resolutionTextField setFrame:NSOffsetRect(self.resolutionTextField.frame, 0, -2 * textFieldHeight)];
        [self.resolutionTextField setStringValue:[NSString stringWithFormat:@"1/%ld", self.loop.resolution]];
        [self addSubview:self.resolutionTextField];
        
        // create length text field
        self.lengthTextField = [self initializeAndConfigureTextField];
        // offset rect by three times textfield height
        [self.lengthTextField setFrame:NSOffsetRect(self.lengthTextField.frame, 0, -3 * textFieldHeight)];
        [self.lengthTextField setStringValue:[NSString stringWithFormat:@"%ld", self.loop.length]];
        [self addSubview:self.lengthTextField];
    }
    return self;
}

-(NSTextField *)initializeAndConfigureTextField
{
    CGFloat textFieldHeight = (self.frame.size.height - 2*PADDING) / 4;
    NSFont *font = [NSFont fontWithName:@"HelveticaNeue-Light" size:20];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSMakeRect(PADDING, self.frame.size.height - PADDING - textFieldHeight, self.frame.size.width - 2 * PADDING, textFieldHeight)];
    [textField setCell:[[RSVerticallyCenteredTextFieldCell alloc] initTextCell:@""]];
    [textField setFont:font];
    [textField setEditable:NO];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    if (self.loop.enabled) {
        [textField setTextColor:[NSColor whiteColor]];
    } else {
        if ([self.loop.creator isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]) {
            [textField setTextColor:[NSColor colorWithDeviceRed:134/255. green:202/255. blue:254/255. alpha:1]];
        } else {
            [textField setTextColor:[NSColor colorWithDeviceRed:162/255. green:134/255. blue:254/255. alpha:1]];
        }
    }
    [textField setAlignment:NSCenterTextAlignment];
    [[textField cell] setLineBreakMode:NSLineBreakByTruncatingTail];
    return textField;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = NSMakeRect([self bounds].origin.x + 3, [self bounds].origin.y + 3, [self bounds].size.width - 6, [self bounds].size.height - 6);
    
    NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:10.0 yRadius:10.0];
    [path addClip];
    
    if (!self.loop.enabled) {
        [[NSColor colorWithDeviceRed:.0 green:.0 blue:.0 alpha:1.] set];
    } else if ([self.loop.creator isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]) {
        [[NSColor colorWithDeviceRed:134/255. green:202/255. blue:254/255. alpha:1] set];
    } else {
        [[NSColor colorWithDeviceRed:162/255. green:134/255. blue:254/255. alpha:1] set];
    }
    
    NSRectFill(rect);
    [super drawRect:dirtyRect];
    if (self.loop.enabled) {
        [[NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1.] set];
        [path setLineWidth:5];
    } else {
        if ([self.loop.creator isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"username"]]) {
            [[NSColor colorWithDeviceRed:134/255. green:202/255. blue:254/255. alpha:1] set];
        } else {
            [[NSColor colorWithDeviceRed:162/255. green:134/255. blue:254/255. alpha:1] set];
        }
        [path setLineWidth:5];
    }
    [path stroke];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    if (self.target) {
        IMP imp = [self.target methodForSelector:self.selector];
        void (*func)(id, SEL) = (void *)imp;
        func(self.target, self.selector);
    }
}

@end
