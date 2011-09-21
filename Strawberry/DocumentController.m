//
//  DocumentController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/17/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "DocumentController.h"

#import "Document.h"

@implementation DocumentController

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag
{
    // Supress normal behavior of creating a new document if there aren't any open windows
    return flag;
}

- (id)makeDocumentWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError
{
    // FIXME: Determine what of document this is: text, binary, folder or project. For now assume text
    return [[Document alloc] initWithContentsOfURL:absoluteURL ofType:@"Text" error:nil];
}

@end
