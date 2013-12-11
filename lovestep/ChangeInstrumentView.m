//
//  ChangeInstrumentView.m
//  lovestep
//
//  Created by Raymond Kennedy on 12/8/13.
//  Copyright (c) 2013 Zachary Waleed Saraf. All rights reserved.
//

#import "ChangeInstrumentView.h"

@interface ChangeInstrumentView ()

// instruments array
@property (nonatomic, strong) NSMutableArray *instruments;
@property (nonatomic, strong) NSTableView *tableView;
@property (nonatomic, strong) NSScrollView *scrollView;

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
        if (instrumentLine.length > 0 && [instrumentLine characterAtIndex:0] == '#') continue;
        NSArray *parsedLine = [instrumentLine componentsSeparatedByString:@":"];
        if (parsedLine.count >= 3) {
            Instrument *instrument = [[Instrument alloc] initWithFluidSynthBank:[parsedLine[0] integerValue]
                                                                        program:[parsedLine[1] integerValue]
                                                                    volumeRatio:[parsedLine[2] floatValue]
                                                                           name:parsedLine[3]];
            [self.instruments addObject:instrument];
        }
    }
}

/*
 * Setup table view
 */
- (void)setupTableView
{
    self.scrollView = [[NSScrollView alloc] initWithFrame:self.bounds];
    self.tableView = [[NSTableView alloc] initWithFrame:self.bounds];
    
    NSTableColumn *column = [[NSTableColumn alloc] initWithIdentifier:@"col"];
    [column setWidth:self.tableView.frame.size.width];
    [self.tableView addTableColumn:column];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[NSColor blueColor]];
    
    [self.scrollView setDocumentView:self.tableView];
    
    [self addSubview:self.scrollView];
}

/*
 * Tableview delegate methods
 */
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    if(view == nil){
        view = [[NSTableCellView alloc]initWithFrame:[tableView frame]];
        view.identifier = [tableColumn identifier];
    }
    
    NSTextField *textfield = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 0, 100, 30)];
    [textfield setStringValue:((Instrument *)([self.instruments objectAtIndex:row])).name];

    [view addSubview:textfield];

    return view;
}


/*
 * Tableview datasource methods
 */
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [self.instruments count];
}

/*
 * Called when the selection changes
 */
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
    [self.delegate instrumentDidChangeToInstrument:[self.instruments objectAtIndex:[self.tableView selectedRow]]];
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
