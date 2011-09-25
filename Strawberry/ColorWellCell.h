//
//  ColorWellCell.h
//  
//
//  Created by CHris Marrin on 9/25/11.
//  Copyright (c) 2011 Apple. All rights reserved.
//
#import <Cocoa/Cocoa.h>

@interface ColorWellCell : NSActionCell
{
    NSTableView* colorPickerTableView;
    NSInteger colorPickerClickedColumn, colorPickerClickedRow;
}

@end
