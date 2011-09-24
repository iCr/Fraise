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
    NSNumber* bold;
    NSNumber* italice;
    NSNumber* underline;
}

@property(copy) NSString* name;
@property(copy) NSColor* fg;
@property(copy) NSColor* bg;
@property(copy) NSNumber* bold;
@property(copy) NSNumber* italic;
@property(copy) NSNumber* underline;

+ (ThemeAttributeModel*) themeAttributeModelWithName:(NSString*)name fg:(NSColor*) fg bg:(NSColor*) bg 
                            bold:(NSNumber*) bold italic:(NSNumber*) italic underline:(NSNumber*) underline; 

@end

@interface PrefThemesController : PrefController <NSTableViewDelegate, NSTableViewDataSource>
{
    IBOutlet NSTableView* table;
    
    NSMutableArray* themeAttributes;
}

+ (PrefThemesController*) controller;

- (void)addThemeAttribute:(ThemeAttributeModel*)themeAttribute;

@end
