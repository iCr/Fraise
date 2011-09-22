//
//  LVColorWellCell.h
//  
//
//  Created by Lakshmi Vyasarajan on 3/19/09.
//  Copyright 2009 Ringce. MIT License.
//
//	Version: 0.5 Beta
//
#import <Cocoa/Cocoa.h>

@interface LVColorWellCell : NSActionCell
{
	id m_delegate;
	NSString* m_colorKey;
	id m_colorObject;	
	NSInteger m_colorRow;	
}

@property (readwrite, copy) NSString* colorKey;
@property (readwrite, assign) id delegate;

@end

@protocol LVColorWellCellDelegate
- (void)colorCell:(LVColorWellCell*)colorCell setColor:(NSColor*)color forRow:(NSInteger)row;
- (NSColor*)colorCell:(LVColorWellCell*)colorCell colorForRow:(NSInteger)row;
@end