//
//  PADropManager.m
//  punakea
//
//  Created by Johannes Hoffart on 08.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PADropManager.h"


@implementation PADropManager

- (id)init
{
	if (self = [super init])
	{
		dropHandlers = [[NSMutableArray alloc] init];
		fileManager = [[PAFileManager alloc] init];
		
		PAFilenamesDropHandler *filenamesDropHandler = [[PAFilenamesDropHandler alloc] init];
		[self registerDropHandler:filenamesDropHandler];
		[filenamesDropHandler release];
	}
	return self;
}

- (void)dealloc
{
	[fileManager release];
	[dropHandlers release];
	[super dealloc];
}

- (void)registerDropHandler:(PADropHandler*)handler
{
	[dropHandlers addObject:handler];
}
	
- (void)removeDropHandler:(PADropHandler*)handler
{
	[dropHandlers removeObject:handler];
}

- (NSArray*)handledPboardTypes
{
	NSMutableArray *handledTypes = [NSMutableArray array];
	
	NSEnumerator *e = [dropHandlers objectEnumerator];
	PADropHandler *dropHandler;
	
	while (dropHandler = [e nextObject])
	{
		[handledTypes addObject:[dropHandler pboardType]];
	}
	
	return handledTypes;
}

- (NSDictionary*)handleDrop:(NSPasteboard*)pasteboard
{
	NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:2];
	
	NSEnumerator *e = [dropHandlers objectEnumerator];
	PADropHandler *dropHandler;
	
	while (dropHandler = [e nextObject])
	{
		if ([dropHandler handleDrop:pasteboard])
		{
			NSArray *files = [fileManager handleFiles:[dropHandler contentFiles]];
			[result setObject:files forKey:@"files"];
			[result setObject:[dropHandler iconForContent] forKey:@"icon"];
		}
	}

	return [result autorelease];
}

@end