//
//  Document.m
//  Strawberry
//
//  Created by Chris Marrin on 9/8/11.

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

#import "Document.h"

#import "DocumentWindowController.h"
#import "ThemeController.h"

@implementation Document

@synthesize encoding, url, content;

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChanged:) name:NotifyThemeChanged object:nil];
    }
    return self;
}

- (void)dealloc
{
    
    [super dealloc];
}

- (void)updateTextView
{
    if (![[self windowControllers] count])
        return;
        
    NSAttributedString* string = [[ThemeController sharedController] highlightCode:content withSuffix:[url pathExtension]];
    if (!string)
        string = [[[NSAttributedString alloc] init] autorelease];;
        
    NSTextView* textView = ((WindowController*) [[self windowControllers] objectAtIndex:0]).textView;
    [textView setBackgroundColor:[[ThemeController sharedController] colorForGeneralType:@"background"]];
    [textView setTextColor:[[ThemeController sharedController] colorForGeneralType:@"foreground"]];
    [textView.textStorage setAttributedString:string];
    [textView setFont:[ThemeController sharedController].font];
}

- (void)themeChanged:(NSNotification*) notification
{
    [self updateTextView];
}

- (void)makeWindowControllers
{
    // FIXME: For now just make a DocumentWindowController. Later on we need to deal with ProjectWindowControllers
    DocumentWindowController* controller = [[DocumentWindowController alloc] initWithWindowNibName:@"Document"];
    [self addWindowController:controller];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)controller
{
    [super windowControllerDidLoadNib:controller];
    
    // FIXME: For now assume a single WindowController
    if (self.content)
        [self updateTextView];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    NSError* error;
    self.url = absoluteURL;
    self.content = [NSMutableString stringWithContentsOfURL:absoluteURL usedEncoding:&encoding error:&error];
    [self updateTextView];
    return true;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    self.content = [data bytes];
    [self updateTextView];
    return YES;
}
 
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // FIXME: Make sure file is ready to save (get text from TextView, call breakUndoCoalescing)
    return [self.content dataUsingEncoding:self.encoding];
}

@end
