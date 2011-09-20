//
//  DocumentController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "DocumentController.h"

@implementation DocumentController

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    // Supress normal behavior of creating a new document if there aren't any open windows
    return flag;
}

@end
