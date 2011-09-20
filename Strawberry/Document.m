//
//  Document.m
//  Strawberry
//
//  Created by Chris Marrin on 9/8/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "Document.h"

#import "DocumentWindowController.h"

@implementation Document

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        // If an error occurs here, return nil.
    }
    return self;
}

- (void)makeWindowControllers
{
    // FIXME: For now just make a DocumentWindowController. Later on we need to deal with ProjectWindowControllers
    DocumentWindowController* controller = [[DocumentWindowController alloc] initWithWindowNibName:@"Document"];
    [self addWindowController:controller];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
