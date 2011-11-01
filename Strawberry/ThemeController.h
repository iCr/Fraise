//
//  ThemeController.h
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

#import <Foundation/Foundation.h>

#define NotifyThemeChanged @"NotifyThemeChanged"

@interface NSColor (ColorAdditions)

+ (NSColor *)colorWithHexString:(NSString *) string;

@end

@interface SyntaxMatch : NSObject
{
    int index, length, typeIndex;
}

@property(assign) int index;
@property(assign) int length;
@property(assign) NSString* type;

@end

@interface ThemeAttributeModel : NSObject
{
    NSString* name;
    NSColor* fg;
    NSColor* bg;
    NSNumber* bold;
    NSNumber* italice;
    NSNumber* underline;
    BOOL locked;
}

@property(copy) NSString* name;
@property(copy) NSColor* fg;
@property(copy) NSColor* bg;
@property(copy) NSNumber* bold;
@property(copy) NSNumber* italic;
@property(copy) NSNumber* underline;
@property BOOL locked;

+ (ThemeAttributeModel*) themeAttributeModelWithName:(NSString*)name attributes:(NSDictionary*)attrs locked:(BOOL)locked; 

@end

@interface ThemeController : NSObject
{
    NSMutableDictionary* themes;
    NSString* currentThemeName;
    NSFont* font;
}

@property(retain) NSString* currentThemeName;
@property(readonly) NSDictionary* currentGeneralTypes;
@property(readonly) NSDictionary* currentSyntaxTypes;
@property(readonly) BOOL currentThemeLocked;
@property(readonly) BOOL currentThemeBuiltin;
@property(readonly) NSArray* themeNames;
@property(readonly) NSFont* font;

+ (ThemeController*)sharedController;

- (NSAttributedString*)highlightCode:(NSString*)code withSuffix:(NSString*)suffix;
- (NSColor*)colorForGeneralType:(NSString*)type;

@end
