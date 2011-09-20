//
//  ProjectWindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "ProjectWindowController.h"

#import "MarkerLineNumberView.h"

@implementation ProjectWindowController

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
}

@end
