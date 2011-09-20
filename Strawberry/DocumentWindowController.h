//
//  DocumentWindowController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MarkerLineNumberView;

@interface DocumentWindowController : NSWindowController
{
    IBOutlet NSScrollView* m_scrollView;
    IBOutlet NSTextView* m_textView;
	MarkerLineNumberView* m_lineNumberView;
}

@end
