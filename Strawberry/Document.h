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
    NSMutableString* m_contents;
    NSStringEncoding m_encoding;
}

@property(readwrite, copy) NSString* contents;
@property(readwrite, assign) NSStringEncoding encoding;

@end
