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
#define kPLAYLIST_TITLE @"playlist title"
#define kSEARCH @"search"
#define kSMART @"smart"
#define kPREDICATE @"predicate"

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
}
- (void) update;

- (NSMutableDictionary *) members;

- (NSMutableDictionary *) searchMembers;
- (void) setSearch:(NSString *) aSearch;

+ (LPlaylist *) musicPlaylist;
+ (LPlaylist *) videoPlaylist;

@property (readwrite, assign) NSString * title;
@property (readwrite, assign) BOOL needsUpdated;
@property (readwrite, assign) NSArray * columns;
@property (readwrite, assign) BOOL smart;
@property (readwrite, assign) NSString * predicate;
@end
