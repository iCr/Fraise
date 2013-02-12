//
//  WindowController.m
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

#import "WindowController.h"

#import "Document.h"
#import "MarkerLineNumberView.h"
#import "ThemeController.h"

@implementation TextView

- (void)drawViewBackgroundInRect:(NSRect)rect
{
    [super drawViewBackgroundInRect:rect];
    NSRange selection = [self selectedRange];
    
    NSRange range = [[self string] lineRangeForRange:selection];
    NSRect boundingRect = [[self layoutManager] boundingRectForGlyphRange:range inTextContainer:[self textContainer]];
    
    boundingRect.origin.x = 0;
    boundingRect.size.width = [self bounds].size.width;
    
    BOOL hasOldLineHighlight = m_lastInsertionPoint >= 0;
    BOOL hasNewLineHighlight = !selection.length;
    
    NSRect newRect;
    
    if (hasNewLineHighlight && hasOldLineHighlight) {
    // Case 1: Going from one insertion point to another -> render new lineHighlight and remove old
        if (NSEqualRects(boundingRect, m_lastLineHighlight) && !NSIntersectsRect(boundingRect, rect))
            return;
        newRect = NSUnionRect(boundingRect, m_lastLineHighlight);
    } else if (hasNewLineHighlight && !hasOldLineHighlight) {
        // Case 2: Going from no insertion point to insertion point -> render new lineHighlight
        newRect = boundingRect;
    } else if (!hasNewLineHighlight && hasOldLineHighlight) {
        // Case 3: Going from insertion point to no insertion point -> render area of old lineHighlight
        newRect = m_lastLineHighlight;
    } else {
        // Nothing to do
        return;
    }
    
    newRect = NSIntersectionRect(newRect, [self visibleRect]);
    
    if (!NSContainsRect(rect, newRect)) {
        [self setNeedsDisplayInRect:NSUnionRect(rect, newRect)];
        return;
    }
        
    NSColor* lineColor = [[ThemeController sharedController] colorForGeneralType:@"lineHighlight"];

    [lineColor set];
    [NSBezierPath fillRect:boundingRect];

    m_lastLineHighlight = boundingRect;
    m_lastInsertionPoint = selection.length ? -1 : selection.location;
}

- (void)setWindowController:(WindowController*)controller;
{
    m_windowController = controller;
    m_lastInsertionPoint = -1;
    m_lastLineHighlight = NSZeroRect;
}

@end

@implementation WindowController

@synthesize textView = m_textView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Create the lineNumberView
    m_lineNumberView = [[MarkerLineNumberView alloc] initWithScrollView:m_scrollView];
    m_lineNumberView.font = [NSFont systemFontOfSize:13];
    [m_scrollView setVerticalRulerView:m_lineNumberView];
    [m_scrollView setHasHorizontalRuler:NO];
    [m_scrollView setHasVerticalRuler:YES];
    [m_scrollView setRulersVisible:YES];
	
    // FIXME: This disables word wrap. Eventually we need this as a per-document flag that gets set when the document is active
    //NSSize layoutSize = [m_textView maxSize];
    //layoutSize.width = layoutSize.height;
    //[m_textView setMaxSize:layoutSize];
    //[[m_textView textContainer] setWidthTracksTextView:NO];
    //[m_textView setHorizontallyResizable:YES];
    //[[m_textView textContainer] setContainerSize:layoutSize];

    [m_textView setWindowController:self];
}

- (NSUInteger)lineNumberForCharacterIndex:(NSUInteger)index
{
    return [m_lineNumberView lineNumberForCharacterIndex:index];
}

@end
