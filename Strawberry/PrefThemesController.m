//
//  ThemeController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefThemesController.h"

#import "AppController.h"
#import "ThemeController.h"

@implementation PrefThemesController

@synthesize tooltip;

+ (PrefThemesController*) controller
{
    return [[[PrefThemesController alloc] init] autorelease];
}

+ (NSString*)label
{
    return @"Themes";
}

+ (NSString*)nibName
{
    return @"PrefThemes";
}

+ (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ProfileFontAndColor.icns"] autorelease];
}

- (void)showCurrentTheme
{
    [m_themeButton selectItemWithTitle:[ThemeController sharedController].currentThemeName];

    BOOL locked = [ThemeController sharedController].currentThemeLocked;
    BOOL builtin = [ThemeController sharedController].currentThemeBuiltin;

    self.tooltip = @"Click on this item to change it";
    if (builtin)
        self.tooltip = @"This theme is built-in and cannot be changed";
    else if (locked)
        self.tooltip = @"This theme is locked. Click the lock icon to unlock it if you want to make changes";

    [themeAttributes removeAllObjects];
    
    NSDictionary* syntaxTypes = [ThemeController sharedController].currentSyntaxTypes;
    for (NSString* name in syntaxTypes) {
        NSDictionary* attrs = [syntaxTypes objectForKey:name];
        [self addThemeAttribute:[ThemeAttributeModel themeAttributeModelWithName:name attributes:attrs locked:locked]];
    }
    
    m_foregroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"foreground"];
    m_foregroundColorWell.toolTip = self.tooltip;
    m_foregroundColorWell.enabled = !locked;
    m_backgroundColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"background"];
    m_backgroundColorWell.toolTip = self.tooltip;
    m_backgroundColorWell.enabled = !locked;
    m_selectionColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"selection"];
    m_selectionColorWell.toolTip = self.tooltip;
    m_selectionColorWell.enabled = !locked;
    m_invisiblesColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"invisibles"];
    m_invisiblesColorWell.toolTip = self.tooltip;
    m_invisiblesColorWell.enabled = !locked;
    m_lineHighlightColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"lineHighlight"];
    m_lineHighlightColorWell.toolTip = self.tooltip;
    m_lineHighlightColorWell.enabled = !locked;
    m_caretColorWell.color = [[ThemeController sharedController] colorForGeneralType:@"caret"];
    m_caretColorWell.toolTip = self.tooltip;
    m_caretColorWell.enabled = !locked;
    
    m_deleteMenuItem.enabled = !builtin;
    
    m_lockButton.state = locked ?  NSOnState :  NSOffState;
    m_lockButton.enabled = !builtin;
    m_lockButton.toolTip = builtin ? @"This theme is built-in and cannot be changed" : (locked ? @"Click to make changes to theme" : @"Click to no longer be able to make changes to theme");
    
    m_fontNameField.stringValue = [NSString stringWithFormat:@"%@ %d pt.", [ThemeController sharedController].currentFontName, (int) [ThemeController sharedController].currentFontSize];
    
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
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"foreground"];
}

- (IBAction)changeBackgroundColor:(id)sender
{
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"background"];
}

- (IBAction)changeSelectionColor:(id)sender
{
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"selection"];
}

- (IBAction)changeInvisiblesColor:(id)sender
{
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"invisibles"];
}

- (IBAction)changeLineHighlightColor:(id)sender
{
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"lineHighlight"];
}

- (IBAction)changeCaretColor:(id)sender
{
    [[ThemeController sharedController] setColor:[sender color] forGeneralType:@"caret"];
}

- (IBAction)duplicateTheme:(id)sender
{
    m_duplicateThemeName.stringValue = @"";
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
    if (returnCode) {
        NSString* name = [m_duplicateThemeName.stringValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![name length]) {
            [AppController showWarningSheetForWindow:[m_view window] messageText:@"Invalid theme name"
                informativeText:@"Name must contain at least one non-whitespace character"];
        } else if ([[ThemeController sharedController] themeExists:name]) {
            [AppController showWarningSheetForWindow:[m_view window] messageText:@"Theme name already in use"
                informativeText:@"Please select a different name"];
        } else {

            [[ThemeController sharedController] duplicateCurrentTheme:m_duplicateThemeName.stringValue];
            [self populateThemeMenu];
        }
        
        [self showCurrentTheme];
    }
}

- (void)doDeleteTheme
{
    [[ThemeController sharedController] deleteCurrentTheme];
    [self populateThemeMenu];
    [self showCurrentTheme];
}

- (IBAction)deleteTheme:(id)sender
{
    if ([ThemeController sharedController].currentThemeBuiltin) {
        [AppController showWarningSheetForWindow:[m_view window] messageText:@"Can't delete built-in theme"
            informativeText:@"This theme is built-in and can't be deleted"];
    } else {
        NSString* name = [ThemeController sharedController] .currentThemeName;
        [AppController showConfirmationSheetForWindow:[m_view window] 
            messageText:[NSString stringWithFormat:@"Delete theme '%@'?", name]
            informativeText:@"Choose OK to delete this theme" target:self selector:@selector(doDeleteTheme)];
    }

    [self showCurrentTheme];
}

- (IBAction)lockButtonToggle:(id)sender
{
    [ThemeController sharedController].currentThemeLocked = m_lockButton.state == NSOnState;
    [self showCurrentTheme];
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
	ThemeAttributeModel* objectAtRow = [themeAttributes objectAtIndex:rowIndex];
	NSString *columnKey = [aTableColumn identifier];
	[objectAtRow setValue:anObject forKey:columnKey];
    [[ThemeController sharedController] setObject:anObject withAttribute:columnKey forSyntaxType:objectAtRow.name];
	[table reloadData];
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 20;
}

- (NSString *)tableView:(NSTableView *)aTableView toolTipForCell:(NSCell *)aCell rect:(NSRectPointer)rect tableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation
{
    return self.tooltip;
}

@end
