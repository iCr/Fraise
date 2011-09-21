//
//  PrefsWindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefsWindowController.h"

@implementation PrefsWindowController

- (void)setupToolbar
{
    NSImage* advancedIcon = [[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarAdvanced.icns"];
    NSImage* generalIcon = [[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/General.icns"];

    [self addView:m_generalPrefsView label:@"General" image:generalIcon];
    [self addView:m_advancedPrefsView label:@"Advanced" image:advancedIcon];
    
    [advancedIcon release];
    [generalIcon release];
}

@end
