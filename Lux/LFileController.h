//
//  LFileController.h
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LFile.h"

#define kFILES @"files"

@interface LFileController : LControllerObject {
	NSMutableDictionary * files;
	
	LFile * activeFile;
}
- (NSDictionary *) files;

- (LFile *) createFileByURL: (NSURL *) url;
- (BOOL) addFileByFile: (LFile *) file;
- (void) addFilesByURL: (NSArray *) files;
- (void) addFileByURL: (NSURL *) url;
- (LFileType) fileTypeForFile:(LFile *)file;

- (void) fileFinishedPlaying: (LFile *)file;
- (void) fileStartedPlaying: (LFile *)file;

- (NSMenu *) menuForFiles: (NSArray *) files;

- (void) showInFinder: (NSMenuItem *) item;
@property (readwrite, assign) LFile * activeFile;
@end
