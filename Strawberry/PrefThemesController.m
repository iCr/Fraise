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
    [themeAttributes removeAllObjects];
    
    NSDictionary* syntaxTypes = [ThemeController sharedController].currentSyntaxTypes;
    for (NSString* name in syntaxTypes) {
        NSDictionary* attrs = [syntaxTypes objectForKey:name];
        [self addThemeAttribute:[ThemeAttributeModel themeAttributeModelWithName:name attributes:attrs]];
    }
    
    m_foregroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"foreground"];
    m_backgroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"background"];
    m_selectionColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"selection"];
    m_invisiblesColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"invisibles"];
    m_lineHighlightColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"lineHighlight"];
    m_caretColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"caret"];
	[table reloadData];
}

- (void)populateThemeMenu
{
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
        
    [m_themeButton selectItemWithTitle:[ThemeController sharedController].currentThemeName];
    if (![m_themeButton selectedItem] || [[m_themeButton selectedItem] tag] < 0) {
        [ThemeController sharedController].currentThemeName = @"Default";
        [m_themeButton selectItemWithTitle:[ThemeController sharedController].currentThemeName];
    }
    
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

- (IBAction)changeForegroundColor:(id)sender
{
}

- (IBAction)changeBackgroundColor:(id)sender
{
}

- (IBAction)changeSelectionColor:(id)sender
{
}

- (IBAction)changeInvisiblesColor:(id)sender
{
}

- (IBAction)changeLineHighlightColor:(id)sender
{
}

- (IBAction)changeCaretColor:(id)sender
{
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
    return 20;
}

@end
