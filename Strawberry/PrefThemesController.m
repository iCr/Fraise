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
    BOOL locked = [ThemeController sharedController].currentThemeLocked;
    
    [themeAttributes removeAllObjects];
    
    NSDictionary* syntaxTypes = [ThemeController sharedController].currentSyntaxTypes;
    for (NSString* name in syntaxTypes) {
        NSDictionary* attrs = [syntaxTypes objectForKey:name];
        [self addThemeAttribute:[ThemeAttributeModel themeAttributeModelWithName:name attributes:attrs locked:locked]];
    }
    
    m_foregroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"foreground"];
    m_foregroundColorWell.enabled = !locked;
    m_backgroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"background"];
    m_backgroundColorWell.enabled = !locked;
    m_selectionColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"selection"];
    m_selectionColorWell.enabled = !locked;
    m_invisiblesColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"invisibles"];
    m_invisiblesColorWell.enabled = !locked;
    m_lineHighlightColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"lineHighlight"];
    m_lineHighlightColorWell.enabled = !locked;
    m_caretColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"caret"];
    m_caretColorWell.enabled = !locked;
    
    m_deleteMenuItem.enabled = !locked;
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
    for (NSAttributedString* name in themeNames) {
        [m_themeButton insertItemWithTitle:@"" atIndex:0];
        [[m_themeButton itemAtIndex:0] setAttributedTitle:name];
    }
        
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
	[table reloadData];
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

- (IBAction)duplicateTheme:(id)sender
{    
    [NSApp beginSheet:m_duplicateSheet modalForWindow:[m_view window] modalDelegate:self 
        didEndSelector:@selector(didEndDuplicateSheet:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)duplicateThemeAccept:(id)sender
{
	[NSApp endSheet:m_duplicateSheet returnCode: NSOKButton];
}

- (IBAction)duplicateThemeCancel:(id)sender
{
    [NSApp endSheet:m_duplicateSheet returnCode: NSCancelButton];
}

- (void)didEndDuplicateSheet:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    [m_duplicateSheet orderOut:self];
    if (returnCode)
        [[ThemeController sharedController] duplicateCurrentTheme:m_duplicateThemeName.stringValue];
}

- (IBAction)deleteTheme:(id)sender
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
	id item = [objectAtRow valueForKey:columnKey];

    ((NSCell*) aTableColumn.dataCell).enabled = !((ThemeAttributeModel*) objectAtRow).locked;

    return item;
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
