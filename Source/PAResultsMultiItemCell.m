//
//  PAResultsMultiItemCell.m
//  punakea
//
//  Created by Daniel on 15.04.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PAResultsMultiItemCell.h"


@implementation PAResultsMultiItemCell

#pragma mark Init + Dealloc
- (id)initTextCell:(NSString *)aText
{
	self = [super initTextCell:aText];
	if (self)
	{
		// nothing
	}	
	return self;
}

- (void)dealloc
{
	if(multiItem) [multiItem release];
	[super dealloc];
}


#pragma mark Drawing
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{	
	NSEnumerator *enumerator = [[controlView subviews] objectEnumerator];
	id anObject;
	
	while(anObject = [enumerator nextObject])
	{
		if([[anObject class] isEqualTo:[PAResultsMultiItemMatrix class]])
		{
			PAResultsMultiItem *thisItem = [(PAResultsMultiItemMatrix *)anObject multiItem];
			if([multiItem isEqualTo:thisItem])
				matrix = anObject;
		}
	}
	
	// Ensure matrix isn't hidden
	[matrix setHidden:NO];
	
	NSRect rect = NSMakeRect(cellFrame.origin.x + 15,
							 cellFrame.origin.y,
							 cellFrame.size.width - 30,
							 cellFrame.size.height);

	if([matrix superview] != controlView)
	{	
		matrix = [[PAResultsMultiItemMatrix alloc] initWithFrame:rect];
		[matrix setCellClass:[multiItem cellClass]];
		[matrix setMultiItem:multiItem];	
		[controlView addSubview:matrix];
	}
	else
	{
		[matrix setFrame:rect];
	}
	
	if(![self isHighlighted])
	{
		[matrix deselectAllCells];
	} else {
		
		if(![matrix selectedCell])
		{
			// Select one item on highlighting
			if([controlView lastUpDownArrowFunctionKey] == NSDownArrowFunctionKey)
			{
				// Select upper left item
				[matrix selectCellAtRow:0 column:0];
				[matrix highlightCell:YES atRow:0 column:0];
			}
			if([controlView lastUpDownArrowFunctionKey] == NSUpArrowFunctionKey)
			{
				// Select lower left item
				[matrix selectCellAtRow:[matrix numberOfRows]-1 column:0];
				[matrix highlightCell:YES atRow:[matrix numberOfRows]-1 column:0];
			}
		}
		[controlView setLastUpDownArrowFunctionKey:0];
		
		// Make matrix the first responder
		[controlView setResponder:matrix];
	}
}

- (void)highlight:(BOOL)flag withFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
	[self drawInteriorWithFrame:cellFrame inView:controlView];
}


#pragma mark Accessors
- (id)objectValue
{
	return multiItem;
}

- (void)setObjectValue:(id <NSCopying>)object
{
	multiItem = (PAResultsMultiItem *)object;
}

@end