//
//  LPlaylist.h
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LStoredObject.h"

#define kMEMBERS @"members"
#define kPLAYLIST_TITLE @"playlistTitle"
#define kSEARCH @"search"
#define kSMART @"smart"
#define kPREDICATE @"predicate"
#define kWRITE @"write"
#define kCOLUMNS @"columns"
#define kSELECTED_INDEX_SET @"selectedIndexSet"

#define kUNTITLED_PLAYLIST @"Liste sans nom"

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
	
	NSIndexSet * selectedIndexSet;
}
- (void) update;
- (void) updateSearch;

- (void) setTitle: (NSString *) title;

- (NSDictionary *) members;
- (NSDictionary *) allMembers;

- (void) setSearch:(NSString *) aSearch;

+ (LPlaylist *) musicPlaylist;
+ (LPlaylist *) videoPlaylist;
+ (LPlaylist *) streamingPlaylist;

@property (readonly, assign) NSString * title;
@property (readwrite, assign) BOOL needsUpdated;
@property (readwrite, assign) BOOL smart;
@property (readwrite, assign) BOOL write;
@property (readwrite, retain) NSArray * columns;
@property (readwrite, retain) NSString * predicate;
@property (readonly, assign) NSString * search;
@property (readwrite, retain) NSIndexSet * selectedIndexSet;
@end
