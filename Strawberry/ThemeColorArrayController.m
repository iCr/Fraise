//
//  ThemeColorArrayController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "ThemeColorArrayController.h"

@implementation ThemeEntry

@synthesize name, fg, bg, bold, italic, underline;

-(id)init
{
    if (self = [super init]) {
        self.name = @"Sample Name";
        self.fg = [NSColor blueColor];
        self.bg = [NSColor greenColor];
        self.bold = true;
        self.italic = false;
        self.underline = true;
    }
    return self;
}

@end

@implementation ThemeColorArrayController

@synthesize themeList = m_themeList;

- (void) awakeFromNib
{
    [super init];
    
}

@end
