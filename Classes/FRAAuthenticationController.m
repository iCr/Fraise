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

#import "FRAAuthenticationController.h"
#import "FRAVariousPerformer.h"
#import "FRAProjectsController.h"
#import "FRAOpenSavePerformer.h"



@implementation FRAAuthenticationController

static id sharedInstance = nil;

+ (FRAAuthenticationController *)sharedInstance
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


- (void)authenticateOpenSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet close];
	[FRAVarious stopModalLoop];
	if (returnCode == NSAlertDefaultReturn) {
		[self performAuthenticatedOpenOfPath:[(NSArray *)contextInfo objectAtIndex:0] withEncoding:[[(NSArray *)contextInfo objectAtIndex:1] unsignedIntegerValue]];
	}
}


- (void)authenticateSaveSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
	[sheet close];
	[FRAVarious stopModalLoop];
	if (returnCode == NSAlertDefaultReturn) {
		[self performAuthenticatedSaveOfDocument:[(NSArray *)contextInfo objectAtIndex:0] data:[(NSArray *)contextInfo objectAtIndex:1] path:[(NSArray *)contextInfo objectAtIndex:2] fromSaveAs:[[(NSArray *)contextInfo objectAtIndex:3] boolValue] aCopy:[[(NSArray *)contextInfo objectAtIndex:4] boolValue]];
	}
}


- (void)performAuthenticatedOpenOfPath:(NSString *)path withEncoding:(NSStringEncoding)encoding
{
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *fileHandle = [pipe fileHandleForReading];
	
    [task setLaunchPath:@"/usr/libexec/authopen"];
    [task setArguments:[NSArray arrayWithObjects:path, nil]];
    [task setStandardOutput:pipe];
	
    [task launch];
	
    NSData *data = [[NSData alloc] initWithData:[fileHandle readDataToEndOfFile]];;
	
	[task waitUntilExit];
	NSInteger status = [task terminationStatus];
	
	if (status != 0) {
		NSString *title = [NSString stringWithFormat:NSLocalizedString(@"There was a unknown error when trying to open the file %@ with authentication", @"Indicate that there was a unknown error when trying to open the file %@ with authentication in Unknown-error-when-opening-with-authentication sheet"), path];
		[FRAVarious standardAlertSheetWithTitle:title message:NSLocalizedString(@"Please check the permissions for the file and the enclosing folder and try again", @"Indicate that they should please check the permissions for the file and the enclosing folder and try again in Unknown-error-when-opening-with-authentication sheet") window:FRACurrentWindow];
	} else {
		[FRAOpenSave shouldOpenPartTwo:path withEncoding:encoding data:data];
	}
}


- (void)performAuthenticatedSaveOfDocument:(id)document data:(NSData *)data path:(NSString *)path fromSaveAs:(BOOL)fromSaveAs aCopy:(BOOL)aCopy
{
	NSString *convertedPath = [NSString stringWithUTF8String:[path UTF8String]];
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	
    [task setLaunchPath:@"/usr/libexec/authopen"];
	[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", convertedPath, nil]];
    [task setStandardInput:pipe];
	
	[task launch];
	[writeHandle writeData:data];
	
	close([writeHandle fileDescriptor]); // Close it manually
	[writeHandle setValue:[NSNumber numberWithUnsignedShort:1] forKey:@"_flags"];
	
	[task waitUntilExit];
	
	NSInteger status = [task terminationStatus];
	
	if (status != 0) {
		NSString *title = [NSString stringWithFormat:NSLocalizedString(@"There was a unknown error when trying to save the file %@ with authentication", @"Indicate that there was a unknown error when trying to save the file %@ with authentication in Unknown-error-when-saving-with-authentication sheet"), path];
		[FRAVarious standardAlertSheetWithTitle:title message:NSLocalizedStringFromTable(@"Please check if the file is locked, on a media that is unwritable or if you can save it in another location", @"Localizable3", @"Please check if the file is locked, on a media that is unwritable or if you can save it in another location") window:FRACurrentWindow];
	} else {
		if (!aCopy) {
			[FRAOpenSave updateAfterSaveForDocument:document path:path];
		}
	}
}


- (void)installCommandLineUtility
{
	NSString *fraisePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"fraise"];
	NSData *fraiseData = [[NSData alloc] initWithContentsOfFile:fraisePath];
	NSString *fraiseManPagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"fraise.1"];
	NSData *fraiseManPageData = [[NSData alloc] initWithContentsOfFile:fraiseManPagePath];
	
	NSTask *task = [[NSTask alloc] init];
    NSPipe *pipe = [[NSPipe alloc] init];
    NSFileHandle *writeHandle = [pipe fileHandleForWriting];
	
    [task setLaunchPath:@"/usr/libexec/authopen"];
    [task setArguments:[NSArray arrayWithObjects:@"-c", @"-m", @"0755", @"-w", @"/usr/bin/fraise", nil]];
    [task setStandardInput:pipe];
	
	[task launch];
	
	NSInteger status;
	signal(SIGPIPE, SIG_IGN); // One seems to need this code if someone writes the wrong password three times, otherwise it crashes the application
	@try {
		[writeHandle writeData:fraiseData];
		
		close([writeHandle fileDescriptor]); // Close it manually
		[writeHandle setValue:[NSNumber numberWithUnsignedShort:1] forKey:@"_flags"];
	}
	@catch (NSException *exception) {
		status = 1;
	}
	@finally {
	}
	
	[task waitUntilExit];
	
	status = [task terminationStatus];
	
	if (status == 0) {
		task = [[NSTask alloc] init];
		pipe = [[NSPipe alloc] init];
		writeHandle = [pipe fileHandleForWriting];
		
		[task setLaunchPath:@"/usr/libexec/authopen"];
		[task setArguments:[NSArray arrayWithObjects:@"-c", @"-w", @"/usr/share/man/man1/fraise.1", nil]];
		[task setStandardInput:pipe];
		
		[task launch];
		[writeHandle writeData:fraiseManPageData];
		
		close([writeHandle fileDescriptor]); // Close it manually
		[writeHandle setValue:[NSNumber numberWithUnsignedShort:1] forKey:@"_flags"];
		
		[task waitUntilExit];
		
		status = [task terminationStatus];
	}
	
	if (status != 0) {
		[FRAVarious standardAlertSheetWithTitle:NSLocalizedString(@"There was a unknown error when trying to install the command-line utility", @"Indicate that there was a unknown error when trying to install the command-linbe utility in Unknown-error-when-installing-comman-line-utility sheet") message:@"" window:FRACurrentWindow];
	}	
}

@end
