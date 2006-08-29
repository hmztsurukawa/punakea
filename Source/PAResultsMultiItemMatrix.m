//
//  PAResultsMultiItemMatrix.m
//  punakea
//
//  Created by Daniel on 17.04.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PAResultsMultiItemMatrix.h"


@implementation PAResultsMultiItemMatrix

#pragma mark Init + Dealloc
- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setCellClass:[PAResultsMultiItemPlaceholderCell class]];
		[self renewRows:1 columns:0];
		[self setIntercellSpacing:NSMakeSize(3, 3)];
		[self setMode:NSHighlightModeMatrix];
		[self setTarget:self];
		
		// Get notification frameDidChange
		[self setPostsFrameChangedNotifications:YES];
		NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self
			   selector:@selector(frameDidChange:)
		           name:(id)NSViewFrameDidChangeNotification
			     object:self];
	}
    return self;
}

- (void)dealloc
{
	if(items) [items release];
	[super dealloc];
}


#pragma mark Notifications
- (void)frameDidChange:(NSNotification *)note
{
	// TODO: Performance!! :)
	
	if([self numberOfRows] <= 0) return;
	
	NSRect frame = [self frame];
	NSSize cellSize = [self cellSize];
	NSSize intercellSpacing = [self intercellSpacing];
	
	int numberOfItemsPerRow = frame.size.width / (cellSize.width + intercellSpacing.width);
	
	// Break if numberOfItemsPerRow hasn't changed
	if([self numberOfColumns] == numberOfItemsPerRow) return;
	
	NSMutableArray *cellArray = [NSMutableArray arrayWithCapacity:100];
	
	for(int row = 0; row < [self numberOfRows]; row++)
	{
		for(int column = 0; column < [self numberOfColumns]; column++)
		{
			NSTextFieldCell *cell = [self cellAtRow:row column:column];
			[cellArray addObject:[cell retain]];
		}
	}
	
	for(int i = 0; i < [self numberOfRows]; i++)
	{
		[self removeRow:i];
	}
	[self renewRows:1 columns:0];
	
	NSTextFieldCell *aCell;
	NSEnumerator *enumerator = [cellArray objectEnumerator];
	int row = 0;
	int column = 0;
	while(aCell = [enumerator nextObject])
	{					
		if(column == numberOfItemsPerRow) 
		{
			[self addRow];
			
			// Fill the new row with placeholder cells
			for(int i = 0; i < column; i++)
			{
				NSTextFieldCell *cell = [[[PAResultsMultiItemPlaceholderCell alloc]
										   initTextCell:@""] autorelease];
				[self putCell:cell atRow:row+1 column:i];
			}
			
			row++;
			column = 0;
		}
		
		// Add columns when adding cells in first row
		if(row == 0)
		{
			[self addColumnWithCells:[NSArray arrayWithObject:aCell]];
		} else {
			[self putCell:aCell atRow:row column:column];
		}
		column++;
		[aCell release];
	}
	
	[self deselectAllCells];
}


#pragma mark Actions
/* TODO
- (void)scrollCellToVisibleAtRow:(int)row column:(int)column
{	
	NSRect cellFrame = [self cellFrameAtRow:row column:column];	
	NSRect frame = [self frame];
	
	NSRect rect = NSMakeRect(frame.origin.x + cellFrame.origin.x,
							 frame.origin.y + cellFrame.origin.y - 40,
							 cellFrame.size.width,
							 cellFrame.size.height + 80);
		
	//if(cellFrame.origin.y < 0) cellFrame.origin.y = 0;
	
	[[self superview] scrollRectToVisible:rect];
}
*/

- (void)displayCellsForItems
{
	for(int i = 0; i < [self numberOfRows]; i++)
	{
		[self removeRow:i];
	}
	[self renewRows:1 columns:0];
	
	NSRect frame = [self frame];
	NSSize cellSize = [self cellSize];
	NSSize intercellSpacing = [self intercellSpacing];
	
	int numberOfItemsPerRow = frame.size.width / (cellSize.width + intercellSpacing.width);
	
	NSEnumerator *enumerator = [items objectEnumerator];
	NSDictionary *anObject;
	
	int row = 0;
	int column = 0;
	while(anObject = [enumerator nextObject])
	{
		NSTextFieldCell *cell =
			[[[[self cellClass] alloc]
				initTextCell:[anObject valueForAttribute:(id)kMDItemDisplayName]] autorelease];				
		[cell setValueDict:anObject];
		
		if(column == numberOfItemsPerRow) 
		{
			[self addRow];
			
			// Fill the new row with placeholder cells
			for(int i = 0; i < column; i++)
			{
				NSTextFieldCell *cell = [[[PAResultsMultiItemPlaceholderCell alloc]
										   initTextCell:@""] autorelease];
				[self putCell:cell atRow:row+1 column:i];
			}
			
			row++;
			column = 0;
		}
		
		// Add columns when adding cells in first row
		//NSLog(@"%d,%d,%d", row, column, numberOfItemsPerRow);
		if(row == 0)
		{
			[self addColumnWithCells:[NSArray arrayWithObject:cell]];
		} else {
			[self putCell:cell atRow:row column:column];
		}
		column++;
	}
}

- (void)moveSelectionUp:(NSEvent *)theEvent
{
	[self moveSelectionUp:theEvent byExtendingSelection:NO];
}

- (void)moveSelectionUp:(NSEvent *)theEvent byExtendingSelection:(BOOL)flag
{	
	NSCell *cell;
	int row = [self numberOfRows] - 1;
	int column = [self numberOfColumns] - 1;
	int r, c;
	NSEnumerator *selCellsEnumerator = [[self selectedCells] objectEnumerator];
	
	while(cell = [selCellsEnumerator nextObject])
	{
		[self getRow:&r column:&c ofCell:cell];
		if(r < row)
		{
			row = r;
			column = c;
		}
		if (r == row && c < column)
		{
			row = r;
			column = c;
		}
	}
	
	if(row != 0) 
	{
		selCellsEnumerator = [[self selectedCells] objectEnumerator];
		[self deselectAllCells];
		
		if(flag)
		{
			while(cell = [selCellsEnumerator nextObject])
			{
				int curRow, curCol;
				[self getRow:&curRow column:&curCol ofCell:cell];
				[self selectCellAtRow:curRow column:curCol];
				[self highlightCell:YES atRow:curRow column:curCol];
			}
		}

		[self selectCellAtRow:row-1 column:column];
		[self highlightCell:YES atRow:row-1 column:column];
	} else {
		// If this is the topmost multi item cell, do nothing as we are at the topmost item
		// in our OutlineView

		NSOutlineView *outlineView = (NSOutlineView *)[self superview];
		int rowInOutlineView = [outlineView rowForItem:items];	
	
		if(rowInOutlineView > 1)
		{
			// Pass keyDown event back to OutlineView
			[[self superview] setResponder:nil];
			[[self superview] keyDown:theEvent];
		}
	}
}

- (void)moveSelectionDown:(NSEvent *)theEvent
{
	[self moveSelectionDown:theEvent byExtendingSelection:NO];
}

- (void)moveSelectionDown:(NSEvent *)theEvent byExtendingSelection:(BOOL)flag
{	
	NSCell *cell;
	int row = 0;
	int column = 0;
	int r, c;
	NSEnumerator *selCellsEnumerator = [[self selectedCells] objectEnumerator];
	
	while(cell = [selCellsEnumerator nextObject])
	{
		[self getRow:&r column:&c ofCell:cell];
		if(r > row)
		{
			row = r;
			column = c;
		}
		if (r == row && c > column)
		{
			row = r;
			column = c;
		}
	}
	
	if(row != [self numberOfRows] - 1) 
	{
		// If the cell that is to be selected represents a placeholder, we will ignore it
		if([[[self cellAtRow:row+1 column:column] class] isEqualTo:[PAResultsMultiItemPlaceholderCell class]])
		{
			column = 0;
		}
	
		selCellsEnumerator = [[self selectedCells] objectEnumerator];
		[self deselectAllCells];
		
		if(flag)
		{
			while(cell = [selCellsEnumerator nextObject])
			{
				int curRow, curCol;
				[self getRow:&curRow column:&curCol ofCell:cell];
				[self selectCellAtRow:curRow column:curCol];
				[self highlightCell:YES atRow:curRow column:curCol];
			}
		}
		
		[self selectCellAtRow:row+1 column:column];
		[self highlightCell:YES atRow:row+1 column:column];
	} else {
		// If this is the lowermost multi item cell, do nothing as we are at the lowermost item
		// in our OutlineView

		NSOutlineView *outlineView = (NSOutlineView *)[self superview];
		int rowInOutlineView = [outlineView rowForItem:items];	
	
		if(rowInOutlineView < [outlineView numberOfRows] - 1)
		{
			// Pass keyDown event back to OutlineView
			[[self superview] setResponder:nil];
			[[self superview] keyDown:theEvent];
		}
	}
}

- (void)moveSelectionRight:(NSEvent *)theEvent
{
	[self moveSelectionRight:theEvent byExtendingSelection:NO];
}

- (void)moveSelectionRight:(NSEvent *)theEvent byExtendingSelection:(BOOL)flag
{	
	NSCell *cell;
	int row = 0;
	int column = 0;
	int r, c;
	NSEnumerator *selCellsEnumerator = [[self selectedCells] objectEnumerator];
	
	while(cell = [selCellsEnumerator nextObject])
	{
		[self getRow:&r column:&c ofCell:cell];
		if(r > row)
		{
			row = r;
			column = c;
		}
		if (r == row && c > column)
		{
			row = r;
			column = c;
		}
	}
	
	column++;
	if(column == [self numberOfColumns])
	{
		// Wrap selection into next line
		column--;
		row++;
	}
	
	// If the cell that is to be selected represents a placeholder, we will ignore it
	// and directly send an arrow down event
	if([[[self cellAtRow:row column:column] class] isEqualTo:[PAResultsMultiItemPlaceholderCell class]])
	{
		row = [self numberOfRows];
	}
	
	if(row != [self numberOfRows]) 
	{
		selCellsEnumerator = [[self selectedCells] objectEnumerator];
		[self deselectAllCells];
		
		if(flag)
		{
			while(cell = [selCellsEnumerator nextObject])
			{
				int curRow, curCol;
				[self getRow:&curRow column:&curCol ofCell:cell];
				[self selectCellAtRow:curRow column:curCol];
				[self highlightCell:YES atRow:curRow column:curCol];
			}
		}		
		
		[self selectCellAtRow:row column:column];
		[self highlightCell:YES atRow:row column:column];
	} else {		
		// Modify event so that selection moves down instead of right (if possible)
		unichar downArrowChar = NSDownArrowFunctionKey;
		theEvent = [NSEvent keyEventWithType:[theEvent type]
		                            location:[self convertPoint:[theEvent locationInWindow] fromView:nil]
							   modifierFlags:[theEvent modifierFlags]
							       timestamp:[theEvent timestamp]
								windowNumber:[theEvent windowNumber]
							         context:[theEvent context]
								  characters:[NSString stringWithCharacters:&downArrowChar length:1]
				 charactersIgnoringModifiers:[NSString stringWithCharacters:&downArrowChar length:1]
								   isARepeat:[theEvent isARepeat]
								     keyCode:125];
		
		[self moveSelectionDown:theEvent byExtendingSelection:flag];
	}
}

- (void)moveSelectionLeft:(NSEvent *)theEvent
{
	[self moveSelectionLeft:theEvent byExtendingSelection:NO];
}

- (void)moveSelectionLeft:(NSEvent *)theEvent byExtendingSelection:(BOOL)flag
{	
	NSCell *cell;
	int row = [self numberOfRows] - 1;
	int column = [self numberOfColumns] - 1;
	int r, c;
	NSEnumerator *selCellsEnumerator = [[self selectedCells] objectEnumerator];
	
	while(cell = [selCellsEnumerator nextObject])
	{
		[self getRow:&r column:&c ofCell:cell];
		if(r < row)
		{
			row = r;
			column = c;
		}
		if (r == row && c < column)
		{
			row = r;
			column = c;
		}
	}
	
	column--;
	if(column == -1)
	{
		// Wrap selection into next line
		column++;
		row--;
	}
	
	if(row != -1) 
	{
		selCellsEnumerator = [[self selectedCells] objectEnumerator];
		[self deselectAllCells];
		
		if(flag)
		{
			while(cell = [selCellsEnumerator nextObject])
			{
				int curRow, curCol;
				[self getRow:&curRow column:&curCol ofCell:cell];
				[self selectCellAtRow:curRow column:curCol];
				[self highlightCell:YES atRow:curRow column:curCol];
			}
		}		
		
		[self selectCellAtRow:row column:column];
		[self highlightCell:YES atRow:row column:column];
	} else {		
		// Modify event so that selection moves up instead of left (if possible)
		unichar upArrowChar = NSUpArrowFunctionKey;
		theEvent = [NSEvent keyEventWithType:[theEvent type]
		                            location:[self convertPoint:[theEvent locationInWindow] fromView:nil]
							   modifierFlags:[theEvent modifierFlags]
							       timestamp:[theEvent timestamp]
								windowNumber:[theEvent windowNumber]
							         context:[theEvent context]
								  characters:[NSString stringWithCharacters:&upArrowChar length:1]
				 charactersIgnoringModifiers:[NSString stringWithCharacters:&upArrowChar length:1]
								   isARepeat:[theEvent isARepeat]
								     keyCode:126];
		
		[self moveSelectionUp:theEvent byExtendingSelection:flag];
	}
}


#pragma mark Events
- (void)keyDown:(NSEvent *)theEvent
{
	if([theEvent type] == NSKeyDown)
	{			
		unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
		
		BOOL shiftKey = ([theEvent modifierFlags] & NSShiftKeyMask) != 0;
			
		switch(key)
		{
			case NSRightArrowFunctionKey: [self moveSelectionRight:theEvent byExtendingSelection:shiftKey];
				break;
			case NSLeftArrowFunctionKey: [self moveSelectionLeft:theEvent byExtendingSelection:shiftKey];
				break;
			case NSUpArrowFunctionKey: [self moveSelectionUp:theEvent byExtendingSelection:shiftKey];
				break;
			case NSDownArrowFunctionKey: [self moveSelectionDown:theEvent byExtendingSelection:shiftKey];
				break;
			default:
				break;
		}
		
		// TODO: Too slow, but we need to invalidate our visibleRect if key was pressed for a while
		//[[self superview] setNeedsDisplayInRect:[[self superview] visibleRect]];
	}
}

- (void)mouseDown:(NSEvent *)theEvent
{		
	NSOutlineView *outlineView = (NSOutlineView *)[self superview];
	
	// Make sure that the outlineView is the first responder
	if([[[outlineView window] firstResponder] isNotEqualTo:outlineView])
	{
		[[outlineView window] makeFirstResponder:outlineView];
	}
	
	// Make sure the corresponding "supercell" is highlighted
	NSPoint locationInOutlineView = [outlineView convertPoint:[theEvent locationInWindow] fromView:nil];
	int row = [outlineView rowAtPoint:locationInOutlineView];	
	BOOL byExtendingSelection = ([theEvent modifierFlags] & NSShiftKeyMask) ||
								([theEvent modifierFlags] & NSCommandKeyMask);	
	[outlineView selectRow:row byExtendingSelection:byExtendingSelection];
	
	NSPoint location = [theEvent locationInWindow];
	location = [self convertPoint:location fromView:nil];
		
	int column;
	[self getRow:&row column:&column forPoint:location];
	
	NSCell *cell = [self cellAtRow:row column:column];
	NSRect cellFrame = [self cellFrameAtRow:row column:column];
	
	// Ask cell to track the mouse and highlight
	[cell trackMouse:theEvent inRect:cellFrame ofView:self untilMouseUp:YES];	
	[self selectCellAtRow:row column:column];
	[cell setHighlighted:YES];
	[self setNeedsDisplayInRect:cellFrame];
		
	// Keep track of selection
	if([theEvent modifierFlags] & NSCommandKeyMask)
	{
		// Extend selection to this cell
		
		// TODO: Deselect if the cell was already highlighted	
		
		// TODO: Support SHIFT key, only COMMAND works atm
	} else {
		// Clear all selections
		NSEnumerator *enumerator = [[self cells] objectEnumerator];
		NSCell *aCell;
		
		while(aCell = [enumerator nextObject])
			if(cell != aCell)
				[aCell setHighlighted:NO];
	}
	
	NSEnumerator *enumerator = [[self selectedCells] objectEnumerator];
	while(cell = [enumerator nextObject])
	{
		NSLog([cell value]);
	}
}


#pragma mark Accessors
- (NSArray *)items
{
	return items;
}

- (void)setItems:(NSArray *)theItems
{
	if(items) [items release];
	items = [theItems retain];
	[self displayCellsForItems];
}

- (void)highlightCell:(BOOL)flag atRow:(int)row column:(int)column
{
	NSCell *cell = [self cellAtRow:row column:column];
	[cell setHighlighted:flag];
}

- (void)setCellClass:(Class)aClass
{
	[super setCellClass:aClass];
	[self setCellSize:[[self cellClass] cellSize]];
	[self setIntercellSpacing:[[self cellClass] intercellSpacing]];
}

@end
