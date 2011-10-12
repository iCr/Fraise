//
//  ThemeController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefThemesController.h"

#import "ThemeController.h"

@implementation PrefThemesController

+ (PrefThemesController*) controller
{
    return [[[PrefThemesController alloc] init] autorelease];
}

- (void)showCurrentTheme
{
    NSDictionary* syntaxTypes = [ThemeController sharedController].currentSyntaxTypes;
    for (NSString* name in syntaxTypes) {
        NSDictionary* attrs = [syntaxTypes objectForKey:name];
        [self addThemeAttribute:[ThemeAttributeModel themeAttributeModelWithName:name attributes:attrs]];
    }
}

- (void)populateThemeMenu
{
    NSString* currentSelection = [m_themeButton titleOfSelectedItem];
    
    while (1) {
        if (![m_themeButton numberOfItems])
            break;
        if ([[m_themeButton itemAtIndex:0] tag] < 0)
            break;
        [m_themeButton removeItemAtIndex:0];
    }
    
    NSArray* themeNames = [ThemeController sharedController].themeNames;
    for (NSString* name in themeNames)
        [m_themeButton insertItemWithTitle:name atIndex:0];
        
    [m_themeButton selectItemWithTitle:currentSelection];
    if (![m_themeButton selectedItem] || [[m_themeButton selectedItem] tag] < 0)
        [m_themeButton selectItemWithTitle:@"Default"];
        
    [self showCurrentTheme];
}

- (id)init
{
    if (self = [super init]) {
        themeAttributes = [[NSMutableArray alloc] init];
        [self populateThemeMenu];
    }
    
    return self;
}

- (void)dealloc
{
    [themeAttributes release];
    [super dealloc];
}

- (IBAction)changeTheme:(id)sender
{
    if ([[sender selectedItem] tag] < 0) {
        // FIXME: Deal with add/delete theme
        return;
    }
    
    [ThemeController sharedController].currentThemeName = [sender titleOfSelectedItem];
    [self showCurrentTheme];
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

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 22;
}

@end
