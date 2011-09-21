//
//  DocumentWindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "DocumentWindowController.h"

#import "Document.h"

@implementation DocumentWindowController

- (void) textDidChange: (NSNotification *) notification
{
    ((Document*) [self document]).contents = [[m_textView textStorage] string];
}

@end
