//
//  ThemeController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.

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

#import "ThemeController.h"

#import "AppController.h"
#import <JSCocoa/JSCocoa.h>

@implementation SyntaxMatch

@synthesize index, length;

+ (NSMutableDictionary*)typeToIndexMap
{
    static NSMutableDictionary* map;
    if (!map)
        map = [[NSMutableDictionary alloc] init];
    return map;
}

- (void)setType:(NSString*) type
{
    static int nextIndex;
    NSNumber* number = [[SyntaxMatch typeToIndexMap] objectForKey:type];
    if (!number) {
        typeIndex = nextIndex++;
        [[SyntaxMatch typeToIndexMap] setObject:[NSNumber numberWithInt:typeIndex] forKey:type];
    }
    else
        typeIndex = [number intValue];
}

- (NSString*)type
{
    for (NSString* key in [SyntaxMatch typeToIndexMap])
        if (typeIndex == [[[SyntaxMatch typeToIndexMap] objectForKey:key] intValue])
            return key;
            
    return nil; 
}

@end

@implementation ThemeController

+ (ThemeController*)sharedController
{
    static ThemeController* controller;
    if (!controller)
        controller = [[ThemeController alloc] init];
    return controller;
}

- (id)init
{
    self = [super init];
    if (self) {
        themes = [[NSMutableDictionary alloc] init];
    
        JSCocoa* js = [AppController lockJSCocoa];
        js.useJSLint = NO;
        
        [js evalJSFile:[[NSBundle mainBundle] pathForResource:@"XRegExp" ofType:@"js"]];
        [js evalJSFile:[[NSBundle mainBundle] pathForResource:@"highlight" ofType:@"js"]];
        
        NSArray* brushes = [[NSBundle mainBundle] pathsForResourcesOfType:@"js" inDirectory:@"brushes"];
        for (NSString* brush in brushes)
            [js evalJSFile:brush];
        
        NSArray* themeFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"js" inDirectory:@"themes"];
        
        for (NSString* themeFile in themeFiles) {
            NSString* string = [NSString stringWithContentsOfFile:themeFile encoding:NSUTF8StringEncoding error:nil];
            NSDictionary* dictionary = [js callFunction:@"doParseJSON" withArguments:[NSArray arrayWithObject:string]];
            NSString* themeName = [dictionary objectForKey:@"name"];
            if (themeName && [themeName length] > 0)
                [themes setObject:dictionary forKey:themeName];
        }
            
        [AppController unlockJSCocoa];
    }
    return self;
}

- (NSAttributedString*)highlightCode:(NSString*)code withSuffix:(NSString*)suffix
{
    if (!code)
        return nil;
        
    JSCocoa* js = [AppController lockJSCocoa];
    
    double now = [NSDate timeIntervalSinceReferenceDate];
    
    JSValueRef result = [js callJSFunctionNamed:@"doSyntaxHighlight" withArguments:code, suffix, nil];
    
    NSLog(@"*** Syntax Highlight took %8.2f seconds\n", [NSDate timeIntervalSinceReferenceDate] - now);
    
    NSArray* array = [js toObject:result];
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:code];
    NSDictionary* testAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
													[NSColor redColor], NSForegroundColorAttributeName,
													nil];
    for (int i = 0; i < [array count]; ++i) {
        SyntaxMatch* match = [array objectAtIndex:i];
        [string setAttributes:testAttrs range:NSMakeRange(match.index, match.length)];
    }

    [AppController unlockJSCocoa];
    return [string autorelease];
}

@end
