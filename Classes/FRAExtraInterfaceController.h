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

#import <Cocoa/Cocoa.h>


@interface FRAExtraInterfaceController : NSObject {

	IBOutlet NSTextField *spacesTextFieldEntabWindow;
	IBOutlet NSTextField *spacesTextFieldDetabWindow;
	IBOutlet NSTextField *lineTextFieldGoToLineWindow;
	IBOutlet NSWindow *entabWindow;
	IBOutlet NSWindow *detabWindow;
	IBOutlet NSWindow *goToLineWindow;
	
	IBOutlet NSView *openPanelAccessoryView;
	IBOutlet NSPopUpButton *openPanelEncodingsPopUp;
	IBOutlet NSButton *openPanelShowHiddenFilesButton;
	
	IBOutlet NSWindow *commandResultWindow;
	IBOutlet NSTextView *commandResultTextView;
	
	IBOutlet NSWindow *newProjectWindow;
	IBOutlet NSPanel *regularExpressionsHelpPanel;
    
    
}


@property (readonly) IBOutlet NSView *openPanelAccessoryView;
@property (readonly) IBOutlet NSPopUpButton *openPanelEncodingsPopUp;
@property (readonly) IBOutlet NSButton *openPanelShowHiddenFilesButton;
@property (readonly) IBOutlet NSWindow *commandResultWindow;
@property (readonly) IBOutlet NSTextView *commandResultTextView;
@property (readonly) IBOutlet NSWindow *newProjectWindow;

+ (FRAExtraInterfaceController *)sharedInstance;

- (void)displayEntab;
- (void)displayDetab;
- (IBAction)entabButtonEntabWindowAction:(id)sender;
- (IBAction)detabButtonDetabWindowAction:(id)sender;
- (IBAction)cancelButtonEntabDetabGoToLineWindowsAction:(id)sender;
- (void)displayGoToLine;
- (IBAction)goButtonGoToLineWindowAction:(id)sender;
- (IBAction)showHiddenFilesButtonAction:(id)sender;

- (void)showCommandResultWindow;


- (IBAction)createNewProjectAction:(id)sender;

- (void)showRegularExpressionsHelpPanel;

@end
