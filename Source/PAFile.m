//
//  PAFile.m
//  punakea
//
//  Created by Johannes Hoffart on 15.09.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PAFile.h"


@implementation PAFile

#pragma mark init+dealloc
// designated initializer
- (id)initWithPath:(NSString*)aPath
{
	if (self = [super init])
	{
		path = [aPath retain];
		workspace = [NSWorkspace sharedWorkspace];
		fileManager = [NSFileManager defaultManager];
	}
	return self;
}

- (id)initWithFileURL:(NSURL*)url
{
	if ([url isFileURL])
	{
		return [self initWithPath:[url path]];
	}
	else
	{
		NSLog(@"error: %@ is not a file URL",url);
		return nil;
	}
}
	
- (void)dealloc
{
	[path release];
	[super dealloc];
}

+ (PAFile*)fileWithPath:(NSString*)aPath
{
	PAFile *file = [[PAFile alloc] initWithPath:aPath];
	return [file autorelease];
}

+ (NSArray*)filesWithFilepaths:(NSArray*)filepaths
{
	NSMutableArray *files = [NSMutableArray array];
	
	NSEnumerator *e = [filepaths objectEnumerator];
	NSString *path;
	
	while (path = [e nextObject])
	{
		[files addObject:[self fileWithPath:path]];
	}
	
	return files;
}
	
+ (PAFile*)fileWithFileURL:(NSURL*)url
{
	PAFile *file = [[PAFile alloc] initWithFileURL:url];
	return [file autorelease];
}

#pragma mark accessors
- (NSString*)path
{
	return path;
}

- (NSString*)name
{
	return [path lastPathComponent];
}

- (NSString*)nameWithoutExtension
{
	return [[self name] stringByDeletingPathExtension];
}

- (NSString*)extension
{
	return [path pathExtension];
}

- (NSString*)directory
{
	return [path stringByDeletingLastPathComponent];
}

- (NSImage*)icon
{
	return [workspace iconForFile:path];
}

- (NSString *)description
{
	return path;
}

#pragma mark euality testing
- (BOOL)isEqual:(id)other 
{
	if (!other || ![other isKindOfClass:[self class]]) 
        return NO;
    if (other == self)
        return YES;
	
    return [self isEqualToFile:other];
}

- (BOOL)isEqualToFile:(PAFile*)otherFile 
{
	if ([path isEqual:[otherFile path]])
		return YES;
	else
		return NO;
}


@end