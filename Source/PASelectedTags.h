//
//  PASelectedTags.h
//  punakea
//
//  Created by Johannes Hoffart on 18.04.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PATag.h"

@interface PASelectedTags : NSObject {
	NSMutableArray *selectedTags;
}

- (id)initWithTags:(NSArray*)tags;

- (NSMutableArray*)selectedTags;
- (void)setSelectedTags:(NSMutableArray*)otherTags;
- (void)insertObject:(PATag *)tag inSelectedTagsAtIndex:(unsigned int)i;
- (void)removeObjectFromSelectedTagsAtIndex:(unsigned int)i;

- (void)removeAllObjectsFromSelectedTags;
- (unsigned int)count;
- (void)addTag:(PATag*)aTag;
- (void)removeTag:(PATag*)aTag;
- (void)addObjectsFromArray:(NSArray*)array;
- (void)removeObjectsInArray:(NSArray*)array;
- (BOOL)containsObject:(PATag*)aTag;
- (NSEnumerator*)objectEnumerator;
- (PATag*)tagAtIndex:(unsigned int)i;

@end