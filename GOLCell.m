//
//  GOLCell.m
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import "GOLCell.h"


// Constants for drawing cells
const CGFloat GOLCellWidth = 12.0;
const CGFloat GOLCellHeight = 12.0;
const CGFloat GOLCellPaddingWidth = 1.0;
const CGFloat GOLCellPaddingHeight = 1.0;

@implementation GOLCell

#pragma mark Attribute Methods

- (BOOL)alive {
	return self.state == NSOnState;
}

- (void)setAlive:(BOOL)alive {
	self.state = alive ? NSOnState : NSOffState;
}

#pragma mark Drawing Methods

- (void)drawWithFrame:(NSRect)cellFrame inView:(id)view {
	NSAffineTransform *innerCellTranslate = [NSAffineTransform transform];
	[NSGraphicsContext saveGraphicsState];
	
	// Draw the outer cell, i.e. the border and padding
	[self drawOuterCellWithFrame:cellFrame inView:view];
	
	// Adjust the rect and coordinates to draw the inner cell
	[innerCellTranslate translateXBy:GOLCellPaddingWidth yBy:GOLCellPaddingHeight];
	cellFrame.size.width -= GOLCellPaddingWidth * 2.0;
	cellFrame.size.height -= GOLCellPaddingHeight * 2.0;
	
	// Draw the inner cell
	[self drawInnerCellWithFrame:cellFrame inView:view];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawOuterCellWithFrame:(NSRect)cellFrame inView:(id)view {
	// Do nothing for now
}

- (void)drawInnerCellWithFrame:(NSRect)cellFrame inView:(id)view {
	self.state == NSOnState ? [[NSColor blackColor] set] : [[NSColor whiteColor] set];
	[NSBezierPath fillRect:cellFrame];
}

@end
