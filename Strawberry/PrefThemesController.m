//
//  ThemeController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefThemesController.h"

@implementation ThemeAttributeModel

@synthesize name, fg, bg, bold, italic, underline;

+ (ThemeAttributeModel*) themeAttributeModelWithName:(NSString*)name fg:(NSColor*) fg bg:(NSColor*) bg 
                            bold:(NSNumber*) bold italic:(NSNumber*) italic underline:(NSNumber*) underline
{
    ThemeAttributeModel* model = [[[ThemeAttributeModel alloc] init] autorelease];
    model.name = name;
    model.fg = fg;
    model.bg = bg;
    model.bold = bold;
    model.italic = italic;
    model.underline = underline;
    return model;
}

- (void)dealloc
{
    self.name = nil;
    self.fg = nil;
    self.bg = nil;
}

@end

@implementation PrefThemesController

+ (PrefThemesController*) controller
{
    return [[[PrefThemesController alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init]) {
        themeAttributes = [[NSMutableArray alloc] init];

        // FIXME: This is just a dummy
        [self addThemeAttribute:[ThemeAttributeModel themeAttributeModelWithName:@"Test Name" fg:[NSColor blueColor] bg:[NSColor greenColor]
            bold:[NSNumber numberWithBool:YES] italic:[NSNumber numberWithBool:NO] underline:[NSNumber numberWithBool:YES]]];
    }
    
    return self;
}

- (void)dealloc
{
    [themeAttributes release];
    [super dealloc];
}

- (NSString*)label
{
    return @"Themes";
}

- (NSString*)nibName
{
    return @"PrefThemes";
}

- (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ProfileFontAndColor.icns"] autorelease];
}

- (void)addThemeAttribute:(ThemeAttributeModel*)themeAttribute
{
    [themeAttributes addObject:themeAttribute];
	[table reloadData];
}

// NSTableViewDataSource overrides
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [themeAttributes count];	
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	id objectAtRow = [themeAttributes objectAtIndex:rowIndex];
	NSString *columnKey = [aTableColumn identifier];
	return 	[objectAtRow valueForKey:columnKey];
}


- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	id objectAtRow = [themeAttributes objectAtIndex:rowIndex];
	NSString *columnKey = [aTableColumn identifier];
	[objectAtRow setValue:anObject forKey:columnKey];
	[table reloadData];
}

@end
