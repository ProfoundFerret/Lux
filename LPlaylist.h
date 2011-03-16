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
}
- (void) update;

- (NSMutableDictionary *) members;

- (NSMutableDictionary *) searchMembers;
- (void) setSearch:(NSString *) aSearch;

+ (LPlaylist *) musicPlaylist;
+ (LPlaylist *) videoPlaylist;
+ (LPlaylist *) streamingPlaylist;

@property (readwrite, assign) NSString * title;
@property (readwrite, assign) BOOL needsUpdated;
@property (readwrite, assign) BOOL smart;
@property (readwrite, assign) BOOL write;
@property (readwrite, assign) NSArray * columns;
@property (readwrite, assign) NSString * predicate;
@property (readonly, assign) NSString * search;
@end
