//
//  PrefController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrefController : NSResponder
{
    IBOutlet NSView* m_view;
    
    NSImage* m_icon;
}

+ (NSString*)label;
+ (NSString*)nibName;
+ (NSImage*)image;

@end
