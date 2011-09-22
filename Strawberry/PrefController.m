//
//  PrefController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefController.h"

#import "PrefsWindowController.h"

@implementation PrefController

- (id)init
{
    [super init];
    [NSBundle loadNibNamed:[self nibName] owner:self];
    [[PrefsWindowController sharedPrefsWindowController] addView:m_view label:[self label] image:[self image]];
    return self;
}

- (NSString*)label
{
    return @"Unknown";
}

- (NSString*)nibName
{
    return @"PrefUnknown";
}

- (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/GenericQuestionMarkIcon.icns"] autorelease];
}

@end
