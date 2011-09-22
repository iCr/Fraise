//
//  PrefGeneralController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefGeneralController.h"

@implementation PrefGeneralController

+ (PrefGeneralController*) controller
{
    return [[[PrefGeneralController alloc] init] autorelease];
}

- (NSString*)label
{
    return @"General";
}

- (NSString*)nibName
{
    return @"PrefGeneral";
}

- (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/General.icns"] autorelease];
}

@end
