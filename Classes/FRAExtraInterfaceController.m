/*
Strawberry - Based on Fraise by Jean-François Moy
Written by Chris Marrin - chris@marrin.com
Find the latest version at http://github.com/cmarrin/Strawberry

Copyright 2010 Jean-François Moy
 
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file 
except in compliance with the License. You may obtain a copy of the License at
 
http://www.apache.org/licenses/LICENSE-2.0
 
Unless required by applicable law or agreed to in writing, software distributed under the 
License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, 
either express or implied. See the License for the specific language governing permissions 
and limitations under the License.
*/

#import "FRAStandardHeader.h"

#import "FRAExtraInterfaceController.h"
#import "FRAFileMenuController.h"
#import "FRATextMenuController.h"
#import "FRAProjectsController.h"
#import "FRAInterfacePerformer.h"
#import "FRAProject.h"


@implementation FRAExtraInterfaceController

@synthesize openPanelAccessoryView, openPanelEncodingsPopUp, openPanelShowHiddenFilesButton, commandResultWindow, commandResultTextView, newProjectWindow;

static id sharedInstance = nil;

+ (FRAExtraInterfaceController *)sharedInstance
{ 
	if (sharedInstance == nil) { 
		sharedInstance = [[self alloc] init];
	}
	
	return sharedInstance;
} 


- (id)init 
{
    if (sharedInstance == nil) {
        sharedInstance = [super init];
		
    }
    return sharedInstance;
}


- (void)displayEntab
{
	if (entabWindow == nil) {
		[NSBundle loadNibNamed:@"FRAEntab.nib" owner:self];
	}
	
	[NSApp beginSheet:entabWindow modalForWindow:FRACurrentWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}


- (void)displayDetab
{
	if (detabWindow == nil) {
		[NSBundle loadNibNamed:@"FRADetab.nib" owner:self];
	}
	
	[NSApp beginSheet:detabWindow modalForWindow:FRACurrentWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}


- (IBAction)entabButtonEntabWindowAction:(id)sender
{
	[NSApp endSheet:[FRACurrentWindow attachedSheet]]; 
	[[FRACurrentWindow attachedSheet] close];
	
	[[FRATextMenuController sharedInstance] performEntab];
}


- (IBAction)detabButtonDetabWindowAction:(id)sender
{
	[NSApp endSheet:[FRACurrentWindow attachedSheet]]; 
	[[FRACurrentWindow attachedSheet] close];
	
	[[FRATextMenuController sharedInstance] performDetab];
}


- (IBAction)cancelButtonEntabDetabGoToLineWindowsAction:(id)sender
{
	[NSApp endSheet:[FRACurrentWindow attachedSheet]]; 
	[[FRACurrentWindow attachedSheet] close];
}


- (void)displayGoToLine
{
	if (goToLineWindow == nil) {
		[NSBundle loadNibNamed:@"FRAGoToLine.nib" owner:self];
	}
	
	[NSApp beginSheet:goToLineWindow modalForWindow:FRACurrentWindow modalDelegate:self didEndSelector:nil contextInfo:nil];
}


- (IBAction)goButtonGoToLineWindowAction:(id)sender
{
	[NSApp endSheet:[FRACurrentWindow attachedSheet]]; 
	[[FRACurrentWindow attachedSheet] close];
	
	[[FRATextMenuController sharedInstance] performGoToLine:[lineTextFieldGoToLineWindow integerValue]];
}

- (IBAction)showHiddenFilesButtonAction:(id)sender
{
    [[FRAFileMenuController sharedInstance] showHiddenFiles:[sender state] == NSOnState];
}

- (NSPopUpButton *)openPanelEncodingsPopUp
{
	if (openPanelEncodingsPopUp == nil) {
		[NSBundle loadNibNamed:@"FRAOpenPanelAccessoryView.nib" owner:self];
	}
	
	return openPanelEncodingsPopUp;
}


- (NSView *)openPanelAccessoryView
{
	if (openPanelAccessoryView == nil) {
		[NSBundle loadNibNamed:@"FRAOpenPanelAccessoryView.nib" owner:self];
	}
	
	return openPanelAccessoryView;
}

- (NSWindow *)commandResultWindow
{
    if (commandResultWindow == nil) {
		[NSBundle loadNibNamed:@"FRACommandResult.nib" owner:self];
		[commandResultWindow setTitle:COMMAND_RESULT_WINDOW_TITLE];
	}
	
	return commandResultWindow;
}


- (NSTextView *)commandResultTextView
{
    if (commandResultTextView == nil) {
		[NSBundle loadNibNamed:@"FRACommandResult.nib" owner:self];
		[commandResultWindow setTitle:COMMAND_RESULT_WINDOW_TITLE];		
	}
	
	return commandResultTextView; 
}


- (void)showCommandResultWindow
{
	[[self commandResultWindow] makeKeyAndOrderFront:nil];
}



- (NSWindow *)newProjectWindow
{
	if (newProjectWindow == nil) {
		[NSBundle loadNibNamed:@"FRANewProject.nib" owner:self];
	}
	
	return newProjectWindow;
}


- (IBAction)createNewProjectAction:(id)sender
{
	if ([[FRADefaults valueForKey:@"WhatKindOfProject"] integerValue] == FRAVirtualProject) {
		[newProjectWindow orderOut:nil]; 
		[[FRAProjectsController sharedDocumentController] newDocument:nil];
		[FRACurrentProject updateWindowTitleBarForDocument:nil];
		[FRACurrentProject selectionDidChange];	
	} else {
		NSSavePanel *savePanel = [NSSavePanel savePanel];
		[savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"strawberryProject"]];
        [savePanel setDirectoryURL:[NSURL URLWithString:[FRAInterface whichDirectoryForSave]]];
        [savePanel beginSheetModalForWindow:newProjectWindow completionHandler:^(NSInteger result) {
            if (result == NSOKButton) {
                [[FRAProjectsController sharedDocumentController] newDocument:nil];
                [FRACurrentProject setFileURL:[savePanel URL]];
                [FRACurrentProject saveToURL:[savePanel URL] ofType:@"strawberryProject" forSaveOperation:NSSaveOperation error:nil];
                [FRACurrentProject updateWindowTitleBarForDocument:nil];
                [FRACurrentProject saveDocument:nil];
            }
        }];
	}	
}

- (void)showRegularExpressionsHelpPanel
{
	if (regularExpressionsHelpPanel == nil) {
		[NSBundle loadNibNamed:@"FRARegularExpressionHelp.nib" owner:self];
	}
	
	[regularExpressionsHelpPanel makeKeyAndOrderFront:nil];
}
@end
