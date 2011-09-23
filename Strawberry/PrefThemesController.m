//
//  ThemeController.m
//  Strawberry
//
//  Created by Chris Marrin on 9/22/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//

#import "PrefThemesController.h"

@implementation ThemeAttributeModel

@synthesize name, fg, bg, bold, italic, underline;

+ (ThemeAttributeModel*) themeAttributeModelWithName:(NSString*)name fg:(NSColor*) fg bg:(NSColor*) bg 
                            bold:(NSNumber*) bold italic:(NSNumber*) italic underline:(NSNumber*) underline
{
    ThemeAttributeModel* model = [[[ThemeAttributeModel alloc] init] autorelease];
    model.name = name;
    model.fg = fg;
    model.bg = bg;
    model.bold = bold;
    model.italic = italic;
    model.underline = underline;
    return model;
}

- (void)dealloc
{
    self.name = nil;
    self.fg = nil;
    self.bg = nil;
}

@end

@implementation PrefThemesController

@synthesize themeAttributes;

+ (PrefThemesController*) controller
{
    return [[[PrefThemesController alloc] init] autorelease];
}

- (id)init
{
    if (self = [super init])
        themeAttributes = [[NSMutableArray alloc] init];
    return self;
}

- (void)dealloc
{
    [themeAttributes release];
    [super dealloc];
}

- (void)awakeFromNib {
    
    // FIXME: This is just a dummy
    [themes addObject:[ThemeAttributeModel themeAttributeModelWithName:@"Test Name" fg:[NSColor blueColor] bg:[NSColor greenColor]
        bold:[NSNumber numberWithBool:YES] italic:[NSNumber numberWithBool:NO] underline:[NSNumber numberWithBool:YES]]];
}

- (NSString*)label
{
    return @"Themes";
}

- (NSString*)nibName
{
    return @"PrefThemes";
}

- (NSImage*)image
{
    return [[[NSImage alloc] initByReferencingFile:@"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ProfileFontAndColor.icns"] autorelease];
}

/*
- (void)awakeFromNib
{
	[self setContent:[NSArray arrayWithObjects:innerObject, outerObject, nil]];
	NSUInteger index = [colorTable columnWithIdentifier:@"color"];
	if (index >= 0){
		NSTableColumn * colorColumn = [[colorTable tableColumns] objectAtIndex:index];
		LVColorWellCell * colorCell = [[LVColorWellCell alloc] init];
		[colorCell setColorKey:@"color"];
		[colorColumn setDataCell:colorCell];
	}
	[self setInner:[innerObject color]];		
	[self setOuter:[outerObject color]];		
	[innerObject addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];
	[outerObject addObserver:self forKeyPath:@"color" options:NSKeyValueObservingOptionNew context:nil];

}

-(LVColorWellCell *)colorCell{
	NSUInteger index = [colorTable columnWithIdentifier:@"color"];
	if (index >= 0){
		NSTableColumn * colorColumn = [[colorTable tableColumns] objectAtIndex:index];
		return [colorColumn dataCell];
	}
	return nil;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (object == innerObject) {
		[self setInner:[innerObject color]];		
	}
	else if (object == outerObject) {
		[self setOuter:[outerObject color]];		
	}
	else {
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

-(BOOL)useDelegate{
	return useDelegate;
}

-(void)setUseDelegate:(BOOL)mustUsedelegate{
	useDelegate = mustUsedelegate;
	[[self colorCell] setDelegate:useDelegate? self : nil];
}

-(void)colorCell:(LVColorWellCell *)colorCell 	
		setColor:(NSColor *)color
		forRow:(int)row{
	NSLog(@"Using Delegate::Set Color For Row:%d", row);
	if (row == 0){
		[innerObject setColor:color];
	} else if (row == 1){
		[outerObject setColor:color];
	}
}

-(NSColor *)colorCell:(LVColorWellCell *)colorCell 	
	colorForRow:(int)row{
	NSLog(@"Using Delegate::Get Color For Row:%d", row);
	if (row == 0){
		return [innerObject color];
	} else if (row == 1){
		return [outerObject color];
	}
	return nil;
}
*/

@end
