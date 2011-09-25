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
    NSTableView* colorPickerTableView;
    NSInteger colorPickerClickedColumn, colorPickerClickedRow;
}

@end
