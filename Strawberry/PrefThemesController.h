//
//  ThemeController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefController.h"

@interface PrefThemesController : PrefController
{
    IBOutlet NSTableView* m_table;
}

+ (PrefThemesController*) controller;

@end
