//
//  LPlaylist.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylist.h"
#import "LExtension.h"
#import "LFileController.h"
#import "LExtension.h"
#import "Lux.h"

#define kMUSIC @"Music"
#define kVIDEO @"Video"
#define kSTREAMING @"Streaming"

@implementation LPlaylist
@synthesize title, needsUpdated, columns, smart, predicate, search, write, selectedIndexSet, needsSearched, repeat, shuffle;
- (id)init
{
    self = [super init];
    if (self) {
		needsUpdated = YES;
		needsSearched = YES;
		smart = NO;
		write = YES;
		
		repeat = NO;
		shuffle = NO;
		
		members = [[NSMutableDictionary alloc] init];
		searchMembers = [[NSMutableDictionary alloc] init];
		columns = [[NSArray alloc] initWithObjects:kINDEX, kTITLE, kARTIST, kALBUM, nil];
		title = kUNTITLED_PLAYLIST;
		search = @"";
		oldSearch = @"";
		predicate = @"";
		
		selectedIndexSet = [[NSIndexSet alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[members release];
	[searchMembers release];
	[columns release];
	
	[title release];
	[search release];
	[oldSearch release];
	
	[selectedIndexSet release];
	
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	needsUpdated = NO;
	needsSearched = YES;
	
	smart = [[aDecoder decodeObjectForKey:kSMART] boolValue];
	write = [[aDecoder decodeObjectForKey:kWRITE] boolValue];
	
	members = [[aDecoder decodeObjectForKey:kMEMBERS] retain];
	columns = [[aDecoder decodeObjectForKey:kCOLUMNS] retain];
	
	title = [[aDecoder decodeObjectForKey:kPLAYLIST_TITLE] retain];
	search = [[aDecoder decodeObjectForKey:kSEARCH] retain];
	predicate = [[aDecoder decodeObjectForKey:kPREDICATE] retain];
	
	selectedIndexSet = [[aDecoder decodeObjectForKey:kSELECTED_INDEX_SET] retain];
	
	repeat = [aDecoder decodeBoolForKey:kREPEAT];
	shuffle = [aDecoder decodeBoolForKey:kSHUFFLE];
		
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:[NSNumber numberWithInt:smart] forKey:kSMART];
	[aCoder encodeObject:[NSNumber numberWithInt:write] forKey:kWRITE];
	
	[aCoder encodeObject:members forKey:kMEMBERS];
	[aCoder encodeObject:columns forKey:kCOLUMNS];
	
	[aCoder encodeObject:title forKey:kPLAYLIST_TITLE];
	[aCoder encodeObject:search forKey:kSEARCH];
	[aCoder encodeObject:predicate forKey:kPREDICATE];
	
	[aCoder encodeObject:selectedIndexSet forKey:kSELECTED_INDEX_SET];
	
	[aCoder encodeBool:repeat forKey:kREPEAT];
	[aCoder encodeBool:shuffle forKey:kSHUFFLE];
	
	[super encodeWithCoder:aCoder];
}

- (id) copy
{
	LPlaylist * playlist = [[LPlaylist alloc] init];
	
	[playlist setNeedsUpdated:needsUpdated];
	[playlist setNeedsSearched: needsSearched];
	
	[playlist setSmart:smart];
	
	[playlist setMembers:[members copy]];
	[playlist setColumns:[columns copy]];
	
	[playlist setTitle:[title copy]];
	
	[playlist setSearch:[search copy]];
	[playlist setPredicate:[predicate copy]];
	
	[playlist setSelectedIndexSet:[selectedIndexSet copy]];
	
	[playlist setRepeat:repeat];
	[playlist setShuffle:shuffle];
	
	return playlist;
}

- (void) update
{
	@synchronized(self)
	{
		if (! needsUpdated || ! smart) return;
		needsUpdated = NO;
		needsSearched = YES;
		
		[members release];
		members = [[NSMutableDictionary alloc] init];
		NSPredicate * pred = [NSPredicate predicateWithFormat:predicate];
		NSDictionary * fileList = [[LFileController sharedInstance] files];

		for (NSString * path in fileList)
		{
			LFile * file = [fileList objectForKey:path];
			BOOL shouldAdd = [pred evaluateWithObject:[file dictionary]];
			if ( shouldAdd )
			{
				[members setObject:file forKey:[file url]];
			}
		}
	}
}

- (NSDictionary *) allMembers
{
	return [NSDictionary dictionaryWithDictionary:members];
}

- (void) setMembers: (NSDictionary *) newMembers
{
	members = [newMembers retain];
}

- (NSDictionary *) members
{
	[self update];
	
	NSDictionary * mList;
	if ([search length])
	{
		[self updateSearch];
		mList = [NSDictionary dictionaryWithDictionary:searchMembers];
	} else {
		mList = [NSDictionary dictionaryWithDictionary:members];
	}
	return mList;
}

- (void) updateSearch
{
	if (! needsSearched || ! [search length]) return;
	needsSearched = NO;
	
	NSDictionary * toBeSearched;
	
	if ([search rangeOfString:oldSearch].location != NSNotFound) // If the new search contains the old one then use old results as a start
	{
		toBeSearched = [NSDictionary dictionaryWithDictionary:searchMembers];
	} else {
		toBeSearched = [NSDictionary dictionaryWithDictionary:members];
	}
	
	NSArray * searchSet = [search componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[searchMembers release];
	searchMembers = [[NSMutableDictionary alloc] init];
	
	for (NSURL * url in toBeSearched)
	{
		LFile * f = [toBeSearched objectForKey:url];
		if ([f matchesSearchSet: searchSet])
		{
			[searchMembers setObject:f forKey:[f url]];
		}
	}
}

- (void) setSearch:(NSString *) aSearch
{
	needsSearched = YES;
	oldSearch = [search retain];
	search = [[aSearch lowercaseString] retain];
	[[Lux sharedInstance] reloadData];
}

+ (LPlaylist *) musicPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	NSString * predicate = [NSString stringWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeAudio];
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	[playlist setTitle:kMUSIC];
	
	[playlist setWrite:NO];
	
	return playlist;
}

+ (LPlaylist *) videoPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	NSString * predicate = [NSString stringWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeVideo];
	
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	[playlist setTitle:kVIDEO];
	
	NSArray * columns = [NSArray arrayWithObjects:kINDEX, kTITLE, nil];
	[playlist setColumns:columns];
	
	[playlist setWrite:NO];
	
	return playlist;
}

+ (LPlaylist *) streamingPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	NSString * predicate = [NSString stringWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeStreaming];

	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	[playlist setTitle:kSTREAMING];
	
	NSArray * columns = [NSArray arrayWithObjects:kINDEX, kTITLE, nil];
	[playlist setColumns:columns];
	
	[playlist setWrite:NO];
	
	return playlist;
}

- (void) addFilesByMenuItem: (NSMenuItem *) menuItem
{
	[self addFiles: [menuItem representedObject]];
}

- (void) addFiles: (NSArray *) newMembers
{
	for (LFile * file in newMembers)
	{
		[members setObject: file forKey: [file url]];
	}
	
	[[Lux sharedInstance] reloadData];
}

- (void) addFile: (LFile *) file
{
	NSArray * files = [NSArray arrayWithObject:file];
	[self addFiles: files];
}

- (void) removeFiles: (NSArray *) newMembers
{
	for (LFile * file in newMembers)
	{
		[members removeObjectForKey:[file url]];
	}
	
	[[Lux sharedInstance] reloadData];
}

- (void) removeFile: (LFile *) file
{
	NSArray * files = [NSArray arrayWithObject:file];
	[self removeFiles: files];
}

- (void) removeFilesByMenuItem: (NSMenuItem *) menuItem
{
	NSArray * files = [menuItem representedObject];
	[self removeFiles:files];
}

- (void) setTitle: (NSString *) newTitle
{
	if (! write) return;
	
	title = newTitle;
}

- (void) toggleRepeat
{
	repeat = ! repeat;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kREPEAT_CHANGED_NOTIFICATION object:nil];
}

- (void) setRepeat:(BOOL) newRepeat
{
	if (newRepeat == repeat) return;
	repeat = newRepeat;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kREPEAT_CHANGED_NOTIFICATION object:nil];
}

- (void) toggleShuffle
{
	shuffle = ! shuffle;
	[[NSNotificationCenter defaultCenter] postNotificationName:kSHUFFLE_CHANGED_NOTIFICATION object:nil];
}

- (void) setShuffle: (BOOL) newShuffle
{
	if (newShuffle == shuffle) return;
	shuffle = newShuffle;
	[[NSNotificationCenter defaultCenter] postNotificationName:kSHUFFLE_CHANGED_NOTIFICATION object:nil];
}
@end
