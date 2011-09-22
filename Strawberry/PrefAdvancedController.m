//
//  PrefAdvancedController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefAdvancedController.h"

@implementation PrefAdvancedController

+ (PrefAdvancedController*) controller
{
    return [[[PrefAdvancedController alloc] init] autorelease];
}

- (NSString*)label
{
    return @"Advanced";
}

- (NSString*)nibName
{
    return @"PrefAdvanced";
}

- (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarAdvanced.icns"] autorelease];
}

@end
