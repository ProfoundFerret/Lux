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
@synthesize title, needsUpdated, columns, smart, predicate, search, write, selectedIndexSet;
- (id)init
{
    self = [super init];
    if (self) {
		needsUpdated = YES;
		needsSearched = YES;
		smart = NO;
		write = YES;
		
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
	
	[super encodeWithCoder:aCoder];
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

- (void) addFiles: (NSArray *) newMembers
{
	for (LFile * file in newMembers)
	{
		[members setObject: file forKey: [file url]];
	}
}

- (void) addFilesByMenuItem: (NSMenuItem *) menuItem
{
	[self addFiles: [menuItem representedObject]];
}

- (void) addFile: (LFile *) file
{
	NSArray * files = [NSArray arrayWithObject:file];
	[self addFiles: files];
}

- (void) setTitle: (NSString *) newTitle
{
	if (! write) return;
	
	title = newTitle;
}
@end
