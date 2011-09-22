//
//  PrefsWindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefsWindowController.h"

#import "PrefThemesController.h"
#import "PrefAdvancedController.h"

@implementation PrefsWindowController

+ (NSString *)nibName;
{
    return @"PrefGeneral";
}

- (void)setupToolbar
{
    NSImage* icon = [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/General.icns"] autorelease];
    [[PrefsWindowController sharedPrefsWindowController] addView:m_view label:@"General" image:icon];
    
    if (!m_panels)
        [m_panels release];
        
    m_panels = [[NSMutableArray alloc] init];
    
    // FIXME: Add other panels in a generic way
    [m_panels addObject:[PrefThemesController controller]];
    [m_panels addObject:[PrefAdvancedController controller]];
    
    
}

@end
