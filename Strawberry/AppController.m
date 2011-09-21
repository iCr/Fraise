//
//  AppController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "AppController.h"

#import "PrefsWindowController.h"

@implementation AppController

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    // Supress normal behavior of creating a new document if there aren't any open windows
    return flag;
}

- (IBAction)openPreferencesWindow:(id)sender
{
  [[PrefsWindowController sharedPrefsWindowController] showWindow:nil];
}

@end
