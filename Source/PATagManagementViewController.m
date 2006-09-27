//
//  PATagManagementViewController.m
//  punakea
//
//  Created by Johannes Hoffart on 13.07.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PATagManagementViewController.h"

@interface PATagManagementViewController (PrivateAPI)

- (void)loadViewForTag:(PATag*)tag;

@end

@implementation PATagManagementViewController

#pragma mark init
- (id)init
{
	if (self = [super init])
	{
		tagger = [PATagger sharedInstance];
		tags = [tagger tags];
		
		[self setWorking:NO];
		
		[NSBundle loadNibNamed:@"TagManagementView" owner:self];
	}
	return self;
}

- (void)awakeFromNib
{
	currentView = mainView;
}

- (void)dealloc
{
	[currentEditedTag release];
	[super dealloc];
}

#pragma mark accessors
- (PATag*)currentEditedTag
{
	return currentEditedTag;
}

- (void)setCurrentEditedTag:(PATag*)aTag
{
	[aTag retain];
	[currentEditedTag release];
	currentEditedTag = aTag;

	[self loadViewForTag:currentEditedTag];
}

- (BOOL)isWorking
{
	return working;
}

- (void)setWorking:(BOOL)flag
{
	working = flag;
}

#pragma mark delegate
- (void)controlTextDidChange:(NSNotification *)aNotification
{
	NSLog(@"didChange");

	NSDictionary *userInfo = [aNotification userInfo];
	NSText *fieldEditor = [userInfo objectForKey:@"NSFieldEditor"];
	NSString *currentName = [fieldEditor string];
	NSString *editedTagName = [currentEditedTag name];

	NSLog(@"edited: %@, current: %@",editedTagName,currentName);

	// DEBUG
	if ([tags tagForName:currentName] != nil)
	{
		NSLog(@"error: %@",[tags tagForName:currentName]);
	}
	
	if ([tags tagForName:currentName] != nil && [currentName isNotEqualTo:editedTagName])
	{
		[fieldEditor setTextColor:[NSColor redColor]];
	} 
	else 
	{
		[fieldEditor setTextColor:[NSColor textColor]];
	}
}

- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor
{
	NSLog(@"shouldEnd");

	NSString *currentName = [fieldEditor string];
	NSString *editedTagName = [currentEditedTag name];
	
	NSLog(@"edited: %@, current: %@",editedTagName,currentName);
	
	if ([tags tagForName:currentName] == nil || [currentName isEqualTo:editedTagName])
		return YES;
	else
		return NO;
}

- (void)controlTextDidEndEditing:(NSNotification *)aNotification
{
	NSLog(@"didEnd");
	
	NSDictionary *userInfo = [aNotification userInfo];
	NSText *fieldEditor = [userInfo objectForKey:@"NSFieldEditor"];
	NSString *currentName = [fieldEditor string];
		
	[self renameTag:currentEditedTag toTagName:currentName];
}

#pragma mark actions
- (void)handleTagActivation:(PATag*)tag
{
	[self setCurrentEditedTag:tag];
}

- (void)loadViewForTag:(PATag*)tag
{
	NSView *sv = [delegate controlledView]; 
	[currentView removeFromSuperview];	
	
	if ([tag isKindOfClass:[PASimpleTag class]])
		currentView = simpleTagManagementView;
		
	[sv addSubview:currentView];			
			
	// TODO this connection needs update
	[tagNameField setObjectValue:[currentEditedTag name]];
}

- (IBAction)removeTag:(id)sender
{
	[self setWorking:YES];
	
	[tagger removeTag:currentEditedTag];
	[tags removeTag:currentEditedTag];
	
	[self setWorking:NO];
}

- (void)renameTag:(PATag*)oldTag toTagName:(NSString*)newTagName
{
	[self setWorking:YES];
	
	[tagger renameTag:[oldTag name] toTag:newTagName];
	[currentEditedTag setName:newTagName];

	[self setWorking:NO];
}
@end