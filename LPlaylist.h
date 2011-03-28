//
//  LPlaylist.h
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LStoredObject.h"
#import "LFile.h"

#define kMEMBERS @"members"
#define kPLAYLIST_TITLE @"playlistTitle"
#define kSEARCH @"search"
#define kSMART @"smart"
#define kPREDICATE @"predicate"
#define kWRITE @"write"
#define kCOLUMNS @"columns"
#define kSELECTED_INDEX_SET @"selectedIndexSet"
#define kREPEAT @"repeat"
#define kSHUFFLE @"shuffle"

#define kREPEAT_CHANGED_NOTIFICATION @"repeatchanged_notification"
#define kSHUFFLE_CHANGED_NOTIFICATION @"shufflechanged_notification"

#define kUNTITLED_PLAYLIST @"Untitled Playlist"

@interface LPlaylist : LStoredObject {
	NSMutableDictionary * members;
	NSMutableDictionary * searchMembers;
	
	NSArray * columns;
	
	NSString * title;
	
	NSString * search;
	NSString * oldSearch;
	
    NSString * predicate;
	
	BOOL needsUpdated;
	BOOL needsSearched;
	
	BOOL smart;
	BOOL write;
	
	BOOL repeat;
	BOOL shuffle;
	
	NSIndexSet * selectedIndexSet;
}
- (void) update;
- (void) updateSearch;

- (void) setTitle: (NSString *) title;

- (NSDictionary *) members;
- (NSDictionary *) allMembers;

- (void) addFiles: (NSArray *) members;
- (void) addFile: (LFile *) file;
- (void) removeFiles: (NSArray *) members;
- (void) removeFile: (LFile *) file;

- (void) addFilesByMenuItem: (NSMenuItem *) menuItem;
- (void) removeFilesByMenuItem: (NSMenuItem *) menuItem;

- (void) setSearch:(NSString *) aSearch;

- (void) setMembers: (NSDictionary *) newMembers;

- (void) toggleRepeat;
- (void) setRepeat: (BOOL) newRepeat;

- (void) toggleShuffle;
- (void) setShuffle: (BOOL) newShuffle;

+ (LPlaylist *) musicPlaylist;
+ (LPlaylist *) videoPlaylist;
+ (LPlaylist *) streamingPlaylist;

@property (readonly, assign) NSString * title;
@property (readwrite, assign) BOOL needsUpdated;
@property (readwrite, assign) BOOL smart;
@property (readwrite, assign) BOOL write;
@property (readonly) BOOL repeat;
@property (readonly) BOOL shuffle;
@property (readwrite, retain) NSArray * columns;
@property (readwrite, retain) NSString * predicate;
@property (readonly, assign) NSString * search;
@property (readwrite, retain) NSIndexSet * selectedIndexSet;
@property (readwrite, assign) BOOL needsSearched;
@end
