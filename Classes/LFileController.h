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
#import "LPlaylist.h"


@interface LFileController : LControllerObject {
	NSMutableDictionary * files;
	NSMutableArray * blacklistURLs;
	
	LFile * activeFile;
}
- (LFile *) createFileByURL: (NSURL *) url;
- (void) addFileByFile: (LFile *) file;
- (void) addFilesByFile: (NSArray *) files;

- (void) addFilesByURL: (NSArray *) files;
- (void) addFileByURL: (NSURL *) url;
- (LFileType) fileTypeForFile:(LFile *)file;

- (void) blacklistURL: (NSURL *) url;
- (void) blacklistURLs: (NSArray *) urls;
- (void) unblacklistURL: (NSURL *) url;
- (void) unblacklistURLs: (NSArray *) urls;

- (void) deleteURLSByMenuItem: (NSMenuItem *) menuItem;

- (void) fileFinishedPlaying: (LFile *)file;
- (void) fileStartedPlaying: (LFile *)file;

- (NSMenu *) menuForFiles: (NSArray *) files;

- (void) showGrowlForFile: (LFile *) file;

- (void) showFiles: (NSArray *) selectFiles inPlaylist: (LPlaylist *) playlist;
- (void) showFilesInPlaylistByMenuItem: (NSMenuItem *) menuItem;

- (void) showInFinder: (NSMenuItem *) item;
@property (readwrite, assign) LFile * activeFile;
@property (readonly) NSMutableDictionary * files;
@end
