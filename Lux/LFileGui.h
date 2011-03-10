//
//  LFileGui.h
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGuiObject.h"

@interface LFileGui : LGuiObject <NSTableViewDataSource> {
    IBOutlet NSTableView *fileList;
	
	NSArray * visibleFiles;
}
@property (readwrite, assign) NSArray * visibleFiles;
@end