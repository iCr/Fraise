//
//  ColorWellCell.m
//  Strawberry
//
//  Created by Chris Marrin on 9/25/11.

/*
Copyright (c) 2009-2011 Chris Marrin (chris@marrin.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    - Redistributions of source code must retain the above copyright notice, this 
      list of conditions and the following disclaimer.

    - Redistributions in binary form must reproduce the above copyright notice, 
      this list of conditions and the following disclaimer in the documentation 
      and/or other materials provided with the distribution.

    - Neither the name of Video Monkey nor the names of its contributors may be 
      used to endorse or promote products derived from this software without 
      specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.
*/

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

	cellFrame = NSInsetRect(cellFrame, 2.0, 2.0);

    // FIXME: This should really be a gradient
    [[NSColor whiteColor] drawSwatchInRect:cellFrame];

	[[NSColor grayColor] setStroke];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    [NSBezierPath strokeRect:cellFrame];
    [[NSGraphicsContext currentContext] setShouldAntialias:YES];

	cellFrame = NSInsetRect(cellFrame, 3.0, 3.0);
	NSColor * color = (NSColor *)[self objectValue];
    [color drawSwatchInRect:cellFrame];
	[[NSColor grayColor] setStroke];
    [[NSGraphicsContext currentContext] setShouldAntialias:NO];
    [NSBezierPath strokeRect:cellFrame];
    [[NSGraphicsContext currentContext] setShouldAntialias:YES];
    
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
