//
//  PAFileCell.h
//  punakea
//
//  Created by Johannes Hoffart on 10.10.06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PAFile.h"
#import "PAThumbnailManager.h"

@interface PAFileCell : NSTextFieldCell {
	PAFile *file;
}

@end
