//
//  PrefsWindowController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefsWindowController.h"

#import "PrefAdvancedController.h"
#import "PrefGeneralController.h"
#import "PrefThemesController.h"

@implementation PrefsWindowController

+ (NSString *)nibName;
{
    return @"";
}

- (void)setupToolbar
{
    if (!m_panels)
        [m_panels release];
        
    m_panels = [[NSMutableArray alloc] init];
    
    // FIXME: Add other panels in a generic way
    [m_panels addObject:[PrefGeneralController controller]];
    [m_panels addObject:[PrefThemesController controller]];
    [m_panels addObject:[PrefAdvancedController controller]];
}

@end
