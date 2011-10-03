//
//  AppController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.

/*
Copyright (c) 2009-2011 Chris Marrin (chris@marrin.com)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

    - Redistributions of source code must retain the above copyright notice, this 
      list of conditions and the following disclaimer.

    - Redistributions in binary form must reproduce the above copyright notice, 
      this list of conditions and the following disclaimer in the documentation 
      and/or other materials provided with the distribution.

    - Neither the name of Video Monkey nor the names of its contributors may be 
      used to endorse or promote products derived from this software without 
      specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH 
DAMAGE.
*/

#import "AppController.h"

#import <JSCocoa/JSCocoa.h>
#import "PrefsWindowController.h"

@implementation AppController

+ (NSRecursiveLock*) JSCocoaMutex
{
    static NSRecursiveLock* sharedMutex;
    if (!sharedMutex)
        sharedMutex = [[NSRecursiveLock alloc] init];
    return sharedMutex;
}

- (id)init
{
    self = [super init];
    if (self) {
        JSCocoa* js = [AppController lockJSCocoa];
        js.useJSLint = NO;
        
        [js evalJSFile:[[NSBundle mainBundle] pathForResource:@"XRegExp" ofType:@"js"]];
        [js evalJSFile:[[NSBundle mainBundle] pathForResource:@"highlight" ofType:@"js"]];
        
        NSArray* brushes = [[NSBundle mainBundle] pathsForResourcesOfType:@"js" inDirectory:@"brushes"];
        for (NSString* brush in brushes)
            [js evalJSFile:brush];
        
        // FIXME: Testing
        //if (js hasJSFunctionNamed:@-
        
        
        [AppController unlockJSCocoa];
    }
    return self;
}

+ (JSCocoa*)lockJSCocoa
{
    [[AppController JSCocoaMutex] lock];
    return [JSCocoaController sharedController];
}

+ (void)unlockJSCocoa
{
    [[AppController JSCocoaMutex] unlock];
}

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
