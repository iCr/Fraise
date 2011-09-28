//
//  Document.h
//  Strawberry
//
//  Created by Chris Marrin on 9/8/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface Document : NSDocument
{
    NSMutableString* content;
    NSStringEncoding encoding;
}

@property(readwrite, copy) NSString* content;
@property(readwrite, assign) NSStringEncoding encoding;

@end
