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

@implementation NSColor (ColorAdditions)

+ (NSColor *)colorWithHexString:(NSString *) string
{
    if (!string || [string characterAtIndex:0] != '#')
        return [NSColor blackColor];
    
    uint32_t value;
    if (![[NSScanner scannerWithString:[string substringFromIndex:1]] scanHexInt:&value])
        return [NSColor blackColor];
        
    float r, g, b, a = 1;

    switch([string length]) {
        case 4: // RGB
            r = (float) ((value >> 8) & 0xf) / 15;
            g = (float) ((value >> 4) & 0xf) / 15;
            b = (float) (value & 0xf) / 15;
            break;
        case 5: // RGBA
            r = (float) ((value >> 12) & 0xf) / 15;
            g = (float) ((value >> 8) & 0xf) / 15;
            b = (float) ((value >> 4) & 0xf) / 15;
            a = (float) (value & 0xf) / 15;
            break;
        case 7: // RRGGBB
            r = (float) ((value >> 16) & 0xff) / 255;
            g = (float) ((value >> 8) & 0xff) / 255;
            b = (float) (value & 0xff) / 255;
            break;
        case 9: // RRGGBBAA
            break;
            r = (float) ((value >> 24) & 0xff) / 255;
            g = (float) ((value >> 16) & 0xff) / 255;
            b = (float) ((value >> 8) & 0xff) / 255;
            a = (float) (value & 0xff) / 255;
        default:
            return [NSColor blackColor];
    }

	return [NSColor colorWithCalibratedRed:r green:g blue:b alpha:a];
}

@end

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

@implementation ThemeAttributeModel

@synthesize name, fg, bg, bold, italic, underline;

+ (ThemeAttributeModel*) themeAttributeModelWithName:(NSString*)name attributes:(NSDictionary*)attrs
{
    ThemeAttributeModel* model = [[[ThemeAttributeModel alloc] init] autorelease];
    model.name = name;
    model.fg = [NSColor colorWithHexString:[attrs objectForKey:@"foreground"]];
    model.bg = [NSColor colorWithHexString:[attrs objectForKey:@"background"]];
    model.bold = [attrs objectForKey:@"bold"];
    model.italic = [attrs objectForKey:@"italic"];
    model.underline = [attrs objectForKey:@"underline"];
    return model;
}

- (void)dealloc
{
    self.name = nil;
    self.fg = nil;
    self.bg = nil;
}

@end

@implementation ThemeController

@synthesize font;

- (NSString*)currentThemeName
{
    return currentThemeName;
}

- (NSArray*)themeNames
{
    NSMutableArray* array = [[[NSMutableArray alloc] init] autorelease];
    for (NSString* name in themes)
        [array addObject:name];
    return array;
}

- (void)setCurrentThemeName:(NSString*) name
{
    currentThemeName = name;
    [[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:currentThemeName forKey:@"currentThemeName"];    
    [[NSNotificationCenter defaultCenter] postNotificationName:NotifyThemeChanged object:nil];
}

- (NSDictionary*)currentTheme
{
    return themes ? [themes objectForKey:currentThemeName] : nil;
}

- (NSDictionary*)currentSyntaxTypes
{
    NSDictionary* styles = [self.currentTheme objectForKey:@"styles"];
    if (!styles)
        return nil;
        
    return [styles objectForKey:@"syntax"];
}

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
        
        currentThemeName = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"currentThemeName"];
        
        NSString* fontName = [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"currentFontName"];
        CGFloat fontSize = [[[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:@"currentFontSize"] floatValue];
        font = [[NSFont fontWithName:fontName size:fontSize] retain];
    }
    return self;
}

- (void)dealloc
{
    [themes release];
    self.currentThemeName = nil;
    [font release];
}

- (NSDictionary*) attributesForSyntaxType:(NSString*)type
{
    NSDictionary* style = [self.currentSyntaxTypes objectForKey:type];
    if (!style)
        return nil;
        
    // FIXME: For now just return foreground color
    NSColor* color = [NSColor colorWithHexString:[style objectForKey:@"foreground"]];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:color, NSForegroundColorAttributeName, nil];
}

- (NSColor*) colorForGeneralType:(NSString*)type
{
    NSDictionary* styles = [self.currentTheme objectForKey:@"styles"];
    if (!styles)
        return nil;
        
    NSDictionary* general = [styles objectForKey:@"general"];
    if (!general)
        return nil;
        
    return [NSColor colorWithHexString:[general objectForKey:type]];
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
    
    for (int i = 0; i < [array count]; ++i) {
        SyntaxMatch* match = [array objectAtIndex:i];
        [string setAttributes:[self attributesForSyntaxType:match.type] range:NSMakeRange(match.index, match.length)];
    }

    [AppController unlockJSCocoa];
    return [string autorelease];
}

@end
