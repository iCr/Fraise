//
//  ThemeController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefController.h"

@class ThemeColorArrayController;
@class ThemeAttributeModel;

@interface PrefThemesController : PrefController <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>
{
    IBOutlet NSTableView* table;
    IBOutlet NSPopUpButton* m_themeButton;
    IBOutlet NSColorWell* m_foregroundColorWell;
    IBOutlet NSColorWell* m_backgroundColorWell;
    IBOutlet NSColorWell* m_selectionColorWell;
    IBOutlet NSColorWell* m_invisiblesColorWell;
    IBOutlet NSColorWell* m_lineHighlightColorWell;
    IBOutlet NSColorWell* m_caretColorWell;
    IBOutlet NSMenuItem* m_deleteMenuItem;
    IBOutlet NSWindow* m_duplicateSheet;
    IBOutlet NSTextField* m_duplicateThemeName;
    IBOutlet NSButton* m_lockButton;
    IBOutlet NSButton* m_fontPanelButton;
    IBOutlet NSTextField* m_fontNameField;
        
    NSMutableArray* themeAttributes;
    
    BOOL m_locked;
    BOOL m_builtin;
    
    NSString* tooltip;
}

@property(retain) NSString* tooltip;

+ (PrefThemesController*) controller;

- (IBAction)changeTheme:(id)sender;
- (IBAction)changeForegroundColor:(id)sender;
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeSelectionColor:(id)sender;
- (IBAction)changeInvisiblesColor:(id)sender;
- (IBAction)changeLineHighlightColor:(id)sender;
- (IBAction)changeCaretColor:(id)sender;
- (IBAction)duplicateTheme:(id)sender;
- (IBAction)duplicateThemeAccept:(id)sender;
- (IBAction)duplicateThemeCancel:(id)sender;
- (IBAction)deleteTheme:(id)sender;
- (IBAction)lockButtonToggle:(id)sender;
- (IBAction)showFontPanel:(id)sender;

- (void)addThemeAttribute:(ThemeAttributeModel*)themeAttribute;

@end
