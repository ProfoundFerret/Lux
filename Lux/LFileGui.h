//
//  LFileGui.h
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGuiObject.h"
#import "LTableView.h"

@interface LFileGui : LGuiObject <NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet LTableView *fileList;
	IBOutlet NSTextField *totalFiles;
	
	NSArray * visibleFiles;
	
	BOOL reloadingData;
}
- (void) updateColumns;
- (void) setupColumns;
- (void) updateTotalFiles;
- (void) selectCorrectFiles;
@property (readwrite, assign) NSArray * visibleFiles;
@end
