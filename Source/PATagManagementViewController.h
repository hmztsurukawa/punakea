//
//  PATagManagementViewController.h
//  punakea
//
//  Created by Johannes Hoffart on 13.07.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PAViewController.h"
#import "PABrowserViewMainControllerProtocol.h"
#import "PATagger.h"
#import "PAQuery.h"

@interface PATagManagementViewController : PAViewController <PABrowserViewMainControllerProtocol> {
	IBOutlet NSView *simpleTagManagementView;
	
	PATagger *tagger;
	
	BOOL deleting;
	BOOL renaming;
}

- (void)handleTagActivation:(PATag*)tag;

- (NSView*)simpleTagManagementView;

- (BOOL)isDeleting;
- (void)setDeleting:(BOOL)flag;
- (BOOL)isRenaming;
- (void)setRenaming:(BOOL)flag;

@end
