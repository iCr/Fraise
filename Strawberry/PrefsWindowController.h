//
//  PrefsWindowController.h
//  Strawberry
//
//  Created by Chris Marrin on 9/20/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "DBPrefsWindowController.h"

@interface PrefsWindowController : DBPrefsWindowController
{
    IBOutlet NSView* m_generalPrefsView;
    IBOutlet NSView* m_themesPrefsView;
    IBOutlet NSView* m_advancedPrefsView;
}

@end