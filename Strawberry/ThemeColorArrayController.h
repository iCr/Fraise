//
//  ThemeColorArrayController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface ThemeEntry : NSObject
{
    NSString* name;
    NSColor* fg;
    NSColor* bg;
    bool bold, italic, underline;
}

@property(readwrite, copy) NSString* name;
@property(readwrite, copy) NSColor* fg;
@property(readwrite, copy) NSColor* bg;
@property(readwrite, assign) bool bold, italic, underline;

@end

@interface ThemeColorArrayController : NSArrayController
{
    IBOutlet NSMutableArray* m_themeList;
}

@property(readonly) NSMutableArray* themeList;

@end
