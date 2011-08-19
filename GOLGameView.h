//
//  GOLGameView.h
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// Constants for drawing the game board
extern const CGFloat GOLBoardPaddingWidth;
extern const CGFloat GOLBoardPaddingHeight;

// Constants for creating the cell grid
extern const unsigned GOLBoardCount;
extern const unsigned GOLColumnCount;
extern const unsigned GOLRowCount;
extern const unsigned GOLEdgeBufferSize;

@interface GOLGameView : NSView {
	NSMutableArray *boards;
	
	unsigned currentBoard, newBoard;
	unsigned lastTouchedRow, lastTouchedColumn;
	NSCellStateValue dragState;
}

// Initialization Methods
- (void)initializeCells;
- (void)resetCells;

// Drawing Methods
- (void)drawBackground:(NSRect)rect;
- (void)drawCells:(NSRect)rect;

// Event Handling Methods
- (void)getIndices:(int *)indices forMouseEvent:(NSEvent *)event;

// Game Logic Methods
- (void)advance:(NSTimer *)firedTimer;
- (void)applyRulesToCellAtRow:(unsigned)row column:(unsigned)column;
- (unsigned)neighborCountForCellAtRow:(unsigned)row column:(unsigned)column;
- (void)rotateBoards;
@end
