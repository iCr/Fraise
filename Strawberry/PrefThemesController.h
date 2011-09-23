//
//  ThemeController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefController.h"

@class ThemeColorArrayController;

@interface ThemeAttributeModel : NSObject
{
    NSString* name;
    NSColor* fg;
    NSColor* bg;
    bool bold, italic, underline;
}

@property(copy) NSString* name;
@property(copy) NSColor* fg;
@property(copy) NSColor* bg;
@property(assign) bool bold, italic, underline;

@end

@interface PrefThemesController : PrefController <NSTableViewDataSource, NSTableViewDelegate>
{
    IBOutlet NSTableView* table;
    IBOutlet NSArrayController* themes;
    
    IBOutlet NSMutableArray* themeAttributes;
}

@property(copy) NSArray* themeAttributes;

+ (PrefThemesController*) controller;

@end
