//
//  GOLGameView.m
//  Game of Life
//
//  Created by Cody Brimhall on 3/23/08.
//  Copyright 2008 Cody Brimhall. All rights reserved.
//

#import "GOLGameView.h"
#import "GOLCell.h"


// Constants for drawing the game board (declared in GOLGameView.h)
const CGFloat GOLBoardPaddingWidth = 3.0;
const CGFloat GOLBoardPaddingHeight = 3.0;

// Constants for creating the cell grid
const unsigned GOLBoardCount = 2;
const unsigned GOLColumnCount = 50;
const unsigned GOLRowCount = 40;
const unsigned GOLEdgeBufferSize = 1;

@implementation GOLGameView

#pragma mark Initialization Methods

- (id)initWithFrame:(NSRect)frame {
	self = [super initWithFrame:frame];
    if(self) {
		currentBoard = 0;
		newBoard = 1;
		
        [self initializeCells];
	}

    return self;
}

- (void)initializeCells {
	unsigned rowsAndEdges = GOLRowCount + (GOLEdgeBufferSize * 2);
	unsigned columnsAndEdges = GOLColumnCount + (GOLEdgeBufferSize * 2);
	int i, n, t;
	
	boards = [[NSMutableArray alloc] initWithCapacity:GOLBoardCount];
	
	// Create GOLBoardCount boards
	for(i = 0; i < GOLBoardCount; i++) {
		NSMutableArray *board = [[NSMutableArray alloc] initWithCapacity:rowsAndEdges];
		
		// Create GOLRowCount rows
		for(n = 0; n < rowsAndEdges; n++) {
			NSMutableArray *row = [[NSMutableArray alloc] initWithCapacity:columnsAndEdges];
			
			// Create GOLColumnCount cells
			for(t = 0; t < columnsAndEdges; t++) {
				GOLCell *cell = [[GOLCell alloc] init];
				
				// Add each cell to a row
				[cell setAllowsMixedState:NO];
				[cell setState:NSOffState];
				[row addObject:cell];
			}
			
			// Add each row to a board
			[board addObject:row];
		}
		
		// Add each board to the board list
		[boards addObject:board];
	}
}

- (void)resetCells {
	NSArray *board = [boards objectAtIndex:currentBoard];
	
	// Dumbly set the state of every cell in the current board to NSOffState
	for(NSArray *row in board)
		for(GOLCell *cell in row)
			[cell setState:NSOffState];
	
	[self setNeedsDisplay:YES];
}

#pragma mark Drawing Methods

- (void)drawRect:(NSRect)rect {
	NSAffineTransform *paddingTranslate = [NSAffineTransform transform];
	[NSGraphicsContext saveGraphicsState];
	
	// Draw the background and border
	[self drawBackground:rect];
	
	// Adjust the drawing bounds for the board padding
	[paddingTranslate translateXBy:GOLBoardPaddingWidth yBy:GOLBoardPaddingHeight];
	[paddingTranslate concat];
	rect.size.width -= GOLBoardPaddingWidth * 2.0;
	rect.size.height -= GOLBoardPaddingHeight * 2.0;
	
	// Draw the cells
	[self drawCells:rect];
	
	[NSGraphicsContext restoreGraphicsState];
}

- (void)drawBackground:(NSRect)rect {
	// Fill the background
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:rect];
	
	// Draw the border
	[[NSColor blackColor] set];
	[NSBezierPath strokeRect:rect];
}

- (void)drawCells:(NSRect)rect {
	NSAffineTransform *rowTranslation = [NSAffineTransform transform];
	NSAffineTransform *columnTranslation = [NSAffineTransform transform];
	NSRect cellRect = NSMakeRect(rect.origin.x, rect.origin.y, GOLCellWidth, GOLCellHeight);
	NSArray *board = [boards objectAtIndex:currentBoard];
	int i, n;
	
	// Define coordinate translations for row and column increments
	[rowTranslation translateXBy:0.0 yBy:GOLCellHeight];
	[columnTranslation translateXBy:GOLCellWidth yBy:0.0];
	
	[NSGraphicsContext saveGraphicsState];
	
	// Iterate over rows, skipping the edge buffer rows
	for(i = GOLEdgeBufferSize; i < GOLRowCount + GOLEdgeBufferSize; i++) {
		NSArray *row = [board objectAtIndex:i];
		
		// Make sure translations done in the next loop don't affect us
		[NSGraphicsContext saveGraphicsState];
		
		// Iterate over cells, drawing each and translating the coordinate system
		for(n = GOLEdgeBufferSize; n < GOLColumnCount + GOLEdgeBufferSize; n++) {
			GOLCell *cell = [row objectAtIndex:n];
			
			[cell drawWithFrame:cellRect inView:self];
			[columnTranslation concat];
		}
		
		[NSGraphicsContext restoreGraphicsState];
		
		[rowTranslation concat];
	}
	
	[NSGraphicsContext restoreGraphicsState];
}

#pragma mark Event Handling

- (void)mouseDown:(NSEvent *)event {
	GOLCell *cell;
	int indices[2];
	
	// Find out where the click was
	[self getIndices:indices forMouseEvent:event];
	
	// If we get back nonsense indices, the click was in the padding.  Ignore it.
	if(indices[0] < 1 || indices[1] < 1)
		return;
	
	// Get the cell and update state information
	cell = [[[boards objectAtIndex:currentBoard] objectAtIndex:indices[0]] objectAtIndex:indices[1]];
	lastTouchedRow = indices[0];
	lastTouchedColumn = indices[1];
	dragState = [cell nextState];
	
	// Update the cell and redraw the board
	[cell setNextState];
	[self setNeedsDisplay:YES];
}

- (void)mouseDragged:(NSEvent *)event {
	GOLCell *cell;
	int indices[2];
	
	// Find out where the drag was
	[self getIndices:indices forMouseEvent:event];
	
	// If we get back nonsense indices, the drag was in the padding.  Ignore it.
	if(indices[0] < 1 || indices[1] < 1)
		return;
	
	// If the drag is still in the same cell as last time, ignore it.
	if(indices[0] == lastTouchedRow && indices[1] == lastTouchedColumn)
		return;
	
	// Get the cell and update state information
	cell = [[[boards objectAtIndex:currentBoard] objectAtIndex:indices[0]] objectAtIndex:indices[1]];
	lastTouchedRow = indices[0];
	lastTouchedColumn = indices[1];
	
	// Update the cell and redraw the board
	[cell setState:dragState];
	[self setNeedsDisplay:YES];
}

- (void)getIndices:(int *)indices forMouseEvent:(NSEvent *)event {
	NSPoint eventLocation = [self convertPoint:[event locationInWindow] fromView:nil];
	
	// If the click was in the padding area, set indices to impossible values
	if((eventLocation.x < GOLBoardPaddingWidth || eventLocation.x > GOLColumnCount * GOLCellWidth + GOLBoardPaddingWidth) || (eventLocation.y < GOLBoardPaddingHeight || eventLocation.y > GOLRowCount * GOLCellHeight + GOLBoardPaddingHeight)) {
		indices[0] = -1;
		indices[1] = -1;
		
		return;
	}
	
	// Adjust for the padding area
	eventLocation.x -= GOLBoardPaddingWidth;
	eventLocation.y -= GOLBoardPaddingHeight;
	
	// Calculate the indices, numbered from 1 (0 == row, 1 == column)
	indices[0] = eventLocation.y / GOLCellHeight + 1;
	indices[1] = eventLocation.x / GOLCellWidth + 1;
}

#pragma mark Game Logic

- (void)advance:(NSTimer *)firedTimer {
	unsigned i, n;
	
	// Build the new board by applying the rules to the current board
	for(i = GOLEdgeBufferSize; i < GOLRowCount + GOLEdgeBufferSize; i++)
		for(n = GOLEdgeBufferSize; n < GOLColumnCount + GOLEdgeBufferSize; n++)
			[self applyRulesToCellAtRow:i column:n];
	
	// Make the new board the current one and redisplay
	[self rotateBoards];
	[self setNeedsDisplay:YES];
}

- (void)applyRulesToCellAtRow:(unsigned)row column:(unsigned)column {
	GOLCell *oldCell = [[[boards objectAtIndex:currentBoard] objectAtIndex:row] objectAtIndex:column];
	GOLCell *newCell = [[[boards objectAtIndex:newBoard] objectAtIndex:row] objectAtIndex:column];
	unsigned neighborCount = [self neighborCountForCellAtRow:row column:column];
	
	// Cells with fewer than two neighbors die of lonliness
	if(oldCell.alive && neighborCount < 2)
		newCell.alive = NO;
	// Cells with more than three neighbors die of starvation
	else if(oldCell.alive && neighborCount > 3)
		newCell.alive = NO;
	// Dead cells with exactly three neighbors come alive
	else if(!oldCell.alive && neighborCount == 3)
		newCell.alive = YES;
	// Otherwise, things stay as they are
	else
		newCell.alive = oldCell.alive;
}

- (unsigned)neighborCountForCellAtRow:(unsigned)row column:(unsigned)column {
	NSArray *board = [boards objectAtIndex:currentBoard];
	NSArray *previousRow, *currentRow, *nextRow;
	unsigned neighborCount = 0;
	int i;
	
	previousRow = [board objectAtIndex:row - 1];
	currentRow = [board objectAtIndex:row];
	nextRow = [board objectAtIndex:row + 1];
	
	// Count neighbors to the north
	for(i = column - 1; i <= column + 1; i++)
		if([[previousRow objectAtIndex:i] alive])
			neighborCount++;
	
	// Count neighbors to the west and east
	if([[currentRow objectAtIndex:column - 1] alive])
		neighborCount++;
	if([[currentRow objectAtIndex:column + 1] alive])
		neighborCount++;
	
	// Count neighbors to the south
	for(i = column - 1; i <= column + 1; i++)
		if([[nextRow objectAtIndex:i] alive])
			neighborCount++;
	
	return neighborCount;
}

- (void)rotateBoards {
	unsigned tmp;
	
	// Rotate the boards; avoid copying by just swaping the index references
	tmp = currentBoard;
	currentBoard = newBoard;
	newBoard = tmp;
}

@end
