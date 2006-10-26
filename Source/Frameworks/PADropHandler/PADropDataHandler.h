//
//  PAFileHandler.h
//  punakea
//
//  Created by Johannes Hoffart on 10.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
abstract class for analyzing the data of a single pboardType. is used by PADropHandler.
 */
@interface PADropDataHandler : NSObject {
	BOOL manageFiles;
	
	NSFileManager *fileManager;
}

/**
if file management is active, the given data will be moved to an internal folder
 the new location is returned
 must be overwritten - abstract
 @param data pdata to file
 @return file with new location
 */
- (NSString*)fileDropData:(id)data;

/**
convenience method, calls handleFile:
 */
- (NSArray*)fileDropDataObjects:(NSArray*)dataObjects;

/**
returns the performed NSDragOperation, depending on fileManager
 must be overwritten - abstract
 @return NSDragOperation which will be performed by this dropDataHandler
 */
- (NSDragOperation)performedDragOperation;

/**
helper methods
 */
- (NSString*)destinationForNewFile:(NSString*)fileName;
- (NSString*)pathForFiles;
- (BOOL)pathIsInManagedHierarchy:(NSString*)path;

@end