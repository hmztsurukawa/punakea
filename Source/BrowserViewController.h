//
//  BrowserViewController.h
//  punakea
//
//  Created by Johannes Hoffart on 27.06.06.
//  Copyright 2006 nudge:nudge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PAViewController.h"

#import "PATypeAheadFind.h"
#import "PATypeAheadView.h"
#import "PABrowserViewMainController.h"
#import "PATagManagementViewController.h"
#import "PAResultsViewController.h"
#import "TaggerController.h"
#import "PASplitView.h"

#import "PASourcePanelController.h"

#import "NNFilterEngine/NNFilterEngine.h"
#import "PAStringFilter.h"
#import "PAStringPrefixFilter.h"
#import "PAContentTypeFilter.h"
#import "PADropManager.h"

#import "lcl.h"

@class PATagCloud;

typedef enum _PATagCloudSortKey {
	PATagCloudNameSortKey = 0,
	PATagCloudRatingSortKey = 1
} PATagCloudSortKey;

typedef enum _PASearchType {
	PATagPrefixSearchType = 0,
	PATagSearchType = 1
} PASearchType;

extern CGFloat const SPLITVIEW_PANEL_MIN_HEIGHT;


@interface BrowserViewController : PAViewController
{
	IBOutlet PATagCloud					*tagCloud;
	IBOutlet PASplitView				*splitView;
	IBOutlet NSView						*controlledView;
	IBOutlet NSMenu						*tagButtonContextualMenu;
			
	PABrowserViewMainController			*mainController;
	
	NNTags								*tags;
	
	NSMutableArray						*visibleTags;			/**< holds the (filtered) tags for TagCloud */
	NNTag								*currentBestTag;		/**< holds the tag with the highest absolute rating currently in visibleTags */
	
	IBOutlet PATypeAheadView			*typeAheadView;
	IBOutlet NSSearchField				*searchField;
	NSString							*searchFieldString;
			
	NSOperationQueue					*filterEngineOpQueue;
	PAStringFilter						*activeFilter;
	NSArray								*activeContentTypeFilters;
	BOOL								filterEngineIsWorking;
	
	NSArray								*contentTypeFilterIdentifiers;
	
	PATagCloudSortKey					sortKey;
	NSSortDescriptor					*sortDescriptor;
	
}

/** 
delegate method, use this another class needs to update the tag cloud
@param someTags tags to be displayed
*/
- (void)setDisplayTags:(NSMutableArray*)someTags; 

/**
use this method to reset the display tags to all available tags
 */
- (void)resetDisplayTags;

/**
highlights tag in tagcloud
 @param tag tag to highlight
 */
- (void)displaySelectedTag:(NNTag*)tag;
- (void)removeActiveTagButton;

- (PABrowserViewMainController*)mainController;

- (NSView*)controlledView;
- (void)makeControlledViewFirstResponder;

/**
is called when a tag is clicked
 */
- (IBAction)tagButtonClicked:(id)sender;
- (IBAction)negatedTagButtonClicked:(id)sender;

- (void)setSearchFieldString:(NSString*)string;

- (void)searchForTags:(NSArray*)someTags;

- (void)manageTags;
- (void)showResults;

- (void)switchMainControllerTo:(PABrowserViewMainController*)controller;

- (void)reset;

- (void)unbindAll;

- (void)reloadData;

// Tag Cloud delegate methods
- (IBAction)includeTag:(id)sender;
- (IBAction)excludeTag:(id)sender;
- (IBAction)editTag:(id)sender;
// --

- (PATagCloud *)tagCloud;
- (NSMenu *)tagButtonContextualMenu;

- (NSArray *)allTags; /**< needed by tagcloud - this will be gone as soon as the tag cloud is a proper view and has no app logic anymore*/

@end
