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

- (IBAction)openPreferencesWindow:(id)sender
{
  [[PrefsWindowController sharedPrefsWindowController] showWindow:nil];
}

@end
