//
//  PADropManager.h
//  punakea
//
//  Created by Johannes Hoffart on 08.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PADropHandler.h"
#import "PAFile.h"
#import "PAFilenamesDropHandler.h"
#import "PABookmarkDictionaryListDropHandler.h"

@interface PADropManager : NSObject {
	NSMutableArray *dropHandlers;
}

/**
get the singleton instance
 @return singleton instance of PADropManager
 */
+ (PADropManager*)sharedInstance;

- (void)registerDropHandler:(PADropHandler*)handler;
- (void)removeDropHandler:(PADropHandler*)handler;

/**
returns an array of strings with all pboardTypes currently
 handled by the dropManager
 @return array of strings with handled pboard types
 */
- (NSArray*)handledPboardTypes;

/**
handles drop and returns file array for drop
 @param pasteboard drop pasteboard
 @return new files for drop data
 */
- (NSArray*)handleDrop:(NSPasteboard*)pasteboard;

@end
