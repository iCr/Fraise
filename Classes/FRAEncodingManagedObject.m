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

#import "FRAEncodingManagedObject.h"
#import "FRAApplicationDelegate.h"
#import "FRATextMenuController.h"
#import "FRAPreferencesController.h"

@implementation FRAEncodingManagedObject


- (void)didChangeValueForKey:(NSString *)key
{	
	[super didChangeValueForKey:key];
	
	if ([[FRAApplicationDelegate sharedInstance] hasFinishedLaunching] == NO) {
		return;
	}
	
	NSMutableArray *activeEncodings = [NSMutableArray arrayWithArray:[FRADefaults valueForKey:@"ActiveEncodings"]];
	if ([[self valueForKey:@"active"] boolValue] == YES) {
		[activeEncodings addObject:[self valueForKey:@"encoding"]];
	} else {
		[activeEncodings removeObject:[self valueForKey:@"encoding"]];
	}
	[FRADefaults setValue:activeEncodings forKey:@"ActiveEncodings"];

	[[FRATextMenuController sharedInstance] buildEncodingsMenus];
	NSUInteger selectedTag = [[[[FRAPreferencesController sharedInstance] encodingsPopUp] selectedItem] tag];
	[[FRAPreferencesController sharedInstance] buildEncodingsMenu];
	[[[FRAPreferencesController sharedInstance] encodingsPopUp] selectItemWithTag:selectedTag];
}
		
		

@end
