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

@interface PrefThemesController : PrefController <NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView* table;
    IBOutlet NSPopUpButton* m_themeButton;
    IBOutlet NSColorWell* m_foregroundColorWell;
    IBOutlet NSColorWell* m_backgroundColorWell;
    IBOutlet NSColorWell* m_selectionColorWell;
    IBOutlet NSColorWell* m_invisiblesColorWell;
    IBOutlet NSColorWell* m_lineHighlightColorWell;
    IBOutlet NSColorWell* m_caretColorWell;
        
    NSMutableArray* themeAttributes;
}

+ (PrefThemesController*) controller;

- (IBAction)changeTheme:(id)sender;
- (IBAction)changeForegroundColor:(id)sender;
- (IBAction)changeBackgroundColor:(id)sender;
- (IBAction)changeSelectionColor:(id)sender;
- (IBAction)changeInvisiblesColor:(id)sender;
- (IBAction)changeLineHighlightColor:(id)sender;
- (IBAction)changeCaretColor:(id)sender;

- (void)addThemeAttribute:(ThemeAttributeModel*)themeAttribute;

@end
