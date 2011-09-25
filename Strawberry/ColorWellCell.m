//
//  ColorWellCell.m
//  
//
//  Created by CHris Marrin on 9/25/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//
#import "ColorWellCell.h"

@implementation ColorWellCell

- (id)init
{
	self = [super init];
	if (self){
		[self setTarget:self];
		[self setAction:@selector(showPicker:)];	
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    return [self init];
}

- (id)initTextCell:(NSString *)aString
{
    return [self init];
}

- (id)initImageCell:(NSImage *)anImage
{
    return [self init];
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[NSGraphicsContext saveGraphicsState];
	[[NSColor whiteColor] setStroke];	
	NSBezierPath * path = [NSBezierPath bezierPathWithRect:cellFrame];
	[path setLineWidth:1];
	[path stroke];	
	cellFrame = NSInsetRect(cellFrame, 2.0, 2.0);
	NSColor * color = (NSColor *)[self objectValue];
    
	if ( [color respondsToSelector:@selector(setFill)] )
		[color drawSwatchInRect:cellFrame];

	[NSGraphicsContext restoreGraphicsState];
}

- (NSColor *)currentTableCellColor:(NSTableView*)table
{
	if ([table clickedColumn] == -1 || [table clickedRow] == -1)
		return nil;

    NSTableColumn* column = [[table tableColumns] objectAtIndex:[table clickedColumn]];
    if (![[column dataCell] isKindOfClass:[ColorWellCell class]])
        return nil;
        
    id <NSTableViewDataSource> data = (id <NSTableViewDataSource>) [table dataSource];
    return [data tableView:table objectValueForTableColumn:column row:[table clickedRow]];
}

- (void)showPicker:(id)sender
{
    colorPickerTableView = sender;
    colorPickerClickedColumn = [sender clickedColumn];
    colorPickerClickedRow = [sender clickedRow];
    
	[[NSColorPanel sharedColorPanel] setContinuous:YES];
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	[[NSColorPanel sharedColorPanel] setTarget:self];
	[[NSColorPanel sharedColorPanel] setAction:@selector(colorChanged:)];
    
    id color = [self currentTableCellColor:sender];
	[[NSColorPanel sharedColorPanel] setColor:color];
	[[NSColorPanel sharedColorPanel] makeKeyAndOrderFront:self];
}

- (void)colorChanged:(id)sender
{
	if (colorPickerClickedColumn == -1 || colorPickerClickedRow == -1)
		return;

    NSTableColumn* column = [[colorPickerTableView tableColumns] objectAtIndex:colorPickerClickedColumn];
    if (![[column dataCell] isKindOfClass:[ColorWellCell class]])
        return;
        
    id <NSTableViewDataSource> data = (id <NSTableViewDataSource>) [colorPickerTableView dataSource];
    [data tableView:colorPickerTableView setObjectValue:[sender color] forTableColumn:column row:colorPickerClickedRow];
}

@end
