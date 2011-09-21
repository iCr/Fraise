//
//  WindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "WindowController.h"

#import "Document.h"
#import "MarkerLineNumberView.h"

@implementation WindowController

@synthesize textView = m_textView;

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];

    // Create the lineNumberView
    m_lineNumberView = [[MarkerLineNumberView alloc] initWithScrollView:m_scrollView];
    [m_scrollView setVerticalRulerView:m_lineNumberView];
    [m_scrollView setHasHorizontalRuler:NO];
    [m_scrollView setHasVerticalRuler:YES];
    [m_scrollView setRulersVisible:YES];
	
    [m_textView setFont:[NSFont userFixedPitchFontOfSize:[NSFont smallSystemFontSize]]];
    
    // FIXME: This disables word wrap. Eventually we need this as a per-document flag that gets set when the document is active
    NSSize layoutSize = [m_textView maxSize];
    layoutSize.width = layoutSize.height;
    [m_textView setMaxSize:layoutSize];
    [[m_textView textContainer] setWidthTracksTextView:NO];
    [m_textView setHorizontallyResizable:YES];
    [[m_textView textContainer] setContainerSize:layoutSize];
}

@end
