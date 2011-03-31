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
#define kSELECTED_FILES @"selectedFiles"
#define kREPEAT @"repeat"
#define kSHUFFLE @"shuffle"
#define kSORT @"sort"
#define kDESCENDING @"descending"
#define kNEEDS_SORTED @"needsSorted"

#define kREPEAT_CHANGED_NOTIFICATION @"repeatchanged_notification"
#define kSHUFFLE_CHANGED_NOTIFICATION @"shufflechanged_notification"

#define kUNTITLED_PLAYLIST @"Untitled Playlist"

#define kSMART_SEARCH_DELIMITER @"?"

@interface LPlaylist : LStoredObject {
	NSMutableArray * members;
	NSMutableArray * searchMembers;
	
	NSArray * columns;
	
	NSString * title;
	
	NSString * search;
	NSString * oldSearch;
	
    NSString * predicate;
	
	NSString * sort;
	
	NSArray * selectedFiles;
	
	BOOL needsUpdated;
	BOOL needsSearched;
	BOOL needsSorted;
	
	BOOL smart;
	BOOL write;
	
	BOOL repeat;
	BOOL shuffle;
	
	BOOL descending;
}
- (void) update;
- (void) updateSearch;
- (void) updateSort;

- (void) setTitle: (NSString *) title;

- (NSArray *) members;
- (NSArray *) allMembers;

- (void) addFiles: (NSArray *) members;
- (void) addFile: (LFile *) file;
- (void) removeFiles: (NSArray *) members;
- (void) removeFile: (LFile *) file;

- (void) addFilesByMenuItem: (NSMenuItem *) menuItem;
- (void) removeFilesByMenuItem: (NSMenuItem *) menuItem;

- (void) setSearch:(NSString *) aSearch;
- (NSString *) createPredicateFromSearch: (NSString *) smartSearch;
- (void) preformSmartSearchWithString: (NSString *) string;

- (void) setMembers: (NSArray *) newMembers;

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
@property (readwrite, retain) NSArray * selectedFiles;
@property (readwrite, assign) BOOL needsSearched;
@property (readwrite, assign) BOOL descending;
@property (readwrite, assign, nonatomic) NSString * sort;
@property (readwrite, assign) BOOL needsSorted;
@end
