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
        
    NSMutableArray* themeAttributes;
}

+ (PrefThemesController*) controller;

- (IBAction)changeTheme:(id)sender;

- (void)addThemeAttribute:(ThemeAttributeModel*)themeAttribute;

@end
