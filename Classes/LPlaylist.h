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

@interface LPlaylist : LStoredObject {
	NSMutableArray * members;
	NSMutableArray * searchMembers;
	
	NSMutableDictionary * columns;
	
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
	
	int limit;
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

- (NSDragOperation) dragOperationForURLs: (NSArray *) urls;

- (void) setSearch:(NSString *) aSearch;
- (NSString *) createPredicateFromSearch: (NSString *) smartSearch;
- (void) preformSmartSearchWithString: (NSString *) string;

- (void) setMembers: (NSArray *) newMembers;

- (void) toggleColumn: (NSString *) column;

- (void) toggleRepeat;
- (void) setRepeat: (BOOL) newRepeat;

- (void) toggleShuffle;
- (void) setShuffle: (BOOL) newShuffle;

- (void) setWidth: (double) width forColumn: (NSString *) column;
- (double) widthForColumn: (NSString *) column;

+ (LPlaylist *) musicPlaylist;
+ (LPlaylist *) videoPlaylist;
+ (LPlaylist *) streamingPlaylist;

@property (readonly, assign) NSString * title;
@property (readwrite, assign) BOOL needsUpdated;
@property (readwrite, assign) BOOL smart;
@property (readwrite, assign) BOOL write;
@property (readonly) BOOL repeat;
@property (readonly) BOOL shuffle;
@property (readwrite, retain, nonatomic) NSMutableDictionary * columns;
@property (readwrite, retain) NSString * predicate;
@property (readonly, assign) NSString * search;
@property (readwrite, retain) NSArray * selectedFiles;
@property (readwrite, assign) BOOL needsSearched;
@property (readwrite, assign) BOOL descending;
@property (readwrite, assign, nonatomic) NSString * sort;
@property (readwrite, assign) BOOL needsSorted;
@property (readwrite, assign) NSString * oldSearch;
@property (readwrite) int limit;
@end
