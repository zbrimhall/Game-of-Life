//
//  GOLCell.h
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// Constants for drawing the cells
extern const CGFloat GOLCellWidth;
extern const CGFloat GOLCellHeight;
extern const CGFloat GOLCellPaddingWidth;
extern const CGFloat GOLCellPaddingHeight;

@interface GOLCell : NSCell {

}

@property(readwrite) BOOL alive;

// Drawing Methods
- (void)drawOuterCellWithFrame:(NSRect)cellFrame inView:(id)view;
- (void)drawInnerCellWithFrame:(NSRect)cellFrame inView:(id)view;
@end
