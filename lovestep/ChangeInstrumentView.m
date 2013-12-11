//
//  ChangeInstrumentView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "ChangeInstrumentView.h"
#import "Instrument.h"

@interface ChangeInstrumentView ()

// instruments array
@property (nonatomic, strong) NSMutableArray *instruments;
@property (nonatomic, strong) NSTableView *tableView;

@end

@implementation ChangeInstrumentView

- (id)initWithFrame:(NSRect)frameRect
{
    if (self = [super initWithFrame:frameRect]) {
        
        [self parseInstruments];
        [self setupTableView];
        [self setAlphaValue:0.95f];
    }
    
    return self;
}

/*
 * Parse the instrument text
 */
- (void)parseInstruments
{
    self.instruments = [[NSMutableArray alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Instruments" ofType:@"txt"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *instrumentLines = [content componentsSeparatedByString:@"\n"];
    for (NSString *instrumentLine in instrumentLines) {
        NSArray *parsedLine = [instrumentLine componentsSeparatedByString:@" "];
        if (parsedLine.count >= 3) {
            NSString *instrumentName = @"";
            for (int i= 2; i < parsedLine.count; i++) {
                instrumentName = [instrumentName stringByAppendingFormat:@"%@ ", parsedLine[i]];
            }
            Instrument *instrument = [[Instrument alloc] initWithFluidSynthProgram:[parsedLine[0] integerValue]
                                                                              bank:[parsedLine[1] integerValue]
                                                                              name:instrumentName];
            NSLog(@"%ld %ld %@", instrument.program, instrument.bank, instrument.name);
            [self.instruments addObject:instrument];
        }
    }
}

/*
 * Setup table view
 */
- (void)setupTableView
{
    self.tableView = [[NSTableView alloc] initWithFrame:self.bounds];
    
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"col"];
    [column setWidth:self.tableView.frame.size.width];
    [self.tableView addTableColumn:column];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[NSColor blueColor]];
    
    [self addSubview:self.tableView];
}

/*
 * Tableview delegate methods
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSView *newView = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, self.frame.size.width, 50))];
    NSTextField *textField = [[NSTextField alloc] initWithFrame:NSRectFromCGRect(CGRectMake(10, 25, self.frame.size.width, 30))];
    [textField setStringValue:((Instrument *)([self.instruments objectAtIndex:row])).name];
    [newView addSubview:textField];
    
    return newView;
}


/*
 * Tableview datasource methods
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    NSLog(@"Number of rows: %d", (int)self.instruments.count);
    return [self.instruments count];
}

/*
 * The row height
 */
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 50;
}

/*
 * Intercept the mouse events
 */
- (void)mouseDown:(NSEvent *)theEvent {}
- (void)mouseDragged:(NSEvent *)theEvent {}
- (void)mouseUp:(NSEvent *)theEvent {}


/*
 * Black bg
 */
- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:1.0f green:1.0f blue:1.0f alpha:1.f] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}


@end
