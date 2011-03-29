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
@synthesize title, needsUpdated, columns, smart, predicate, search, write, selectedIndexSet, needsSearched, repeat, shuffle, sort, descending, needsSorted;
- (id)init
{
    self = [super init];
    if (self) {
		needsUpdated = YES;
		needsSearched = YES;
		needsSorted = YES;
		
		smart = NO;
		write = YES;
		
		repeat = NO;
		shuffle = NO;
		
		members = [[NSMutableArray alloc] init];
		searchMembers = [[NSMutableArray alloc] init];
		columns = [[NSArray alloc] initWithObjects:kINDEX, kTITLE, kARTIST, kALBUM, nil];
		title = kUNTITLED_PLAYLIST;
		search = @"";
		oldSearch = @"";
		predicate = @"";
		sort = kARTIST;
		
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
	[sort release];
	[predicate release];
	[sort release];
	
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
	
	sort = [aDecoder decodeObjectForKey:kSORT];
	needsSorted = YES;
	descending = [aDecoder decodeBoolForKey:kDESCENDING];
		
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
	
	[aCoder encodeObject:sort forKey:kSORT];
	[aCoder encodeBool:needsSorted forKey:kNEEDS_SORTED];
	[aCoder encodeBool:descending forKey:kDESCENDING];
	
	[super encodeWithCoder:aCoder];
}

- (id) copy
{
	LPlaylist * playlist = [[LPlaylist alloc] init];
	
	[playlist setNeedsUpdated:needsUpdated];
	[playlist setNeedsSearched: needsSearched];
	
	[playlist setSmart:smart];
	
	[playlist setMembers:[[members copy] autorelease]];
	[playlist setColumns:[[columns copy] autorelease]];
	
	[playlist setTitle:[[title copy] autorelease]];
	
	[playlist setSearch:[[search copy] autorelease]];
	[playlist setPredicate:[[predicate copy] autorelease]];
	
	[playlist setSelectedIndexSet:[[selectedIndexSet copy] autorelease]];
	
	[playlist setRepeat:repeat];
	[playlist setShuffle:shuffle];
	
	[playlist setSort:[[sort copy] autorelease]];
	[playlist setNeedsSorted:needsSorted];
	[playlist setDescending:descending];
	
	return playlist;
}

- (void) update
{
	@synchronized(self)
	{
		if (! needsUpdated || ! smart) return;
		needsUpdated = NO;
		needsSearched = YES;
		needsSorted = YES;
		
		[members release];
		members = [[NSMutableArray alloc] init];
		NSPredicate * pred = [NSPredicate predicateWithFormat:predicate];
		NSArray * fileList = [[[LFileController sharedInstance] files] allValues];

		for (LFile * file in fileList)
		{
			BOOL shouldAdd = [pred evaluateWithObject:[file dictionary]] && ! [members containsObject:file];
			if ( shouldAdd )
			{
				[members addObject:file];
			}
		}
	}
}

- (NSArray *) allMembers
{
	[self update];
	return [NSArray arrayWithArray:members];
}

- (void) setMembers: (NSArray *) newMembers
{
	members = [newMembers retain];
}

- (NSArray *) members
{
	[self update];
	
	NSArray * mList;
	if ([search length])
	{
		[self updateSearch];
		mList = searchMembers;
	} else {
		mList = members;
	}
	
	mList = [self updateSort: mList];
	return [NSArray arrayWithArray:mList];
}

- (NSArray *) updateSort: (NSArray *) files
{
	if (! needsSorted) return files;
	needsSorted = NO;
	
	NSString * key = [NSString stringWithFormat:@"dictionary.%@", sort];
	NSString * keyArtist = [NSString stringWithFormat:@"dictionary.%@", kARTIST];
	NSString * keyAlbum = [NSString stringWithFormat:@"dictionary.%@", kALBUM];
	NSString * keyTitle = [NSString stringWithFormat:@"dictionary.%@", kTITLE];
	
	NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:! descending];
	NSSortDescriptor * sortDescriptorArtist = [NSSortDescriptor sortDescriptorWithKey:keyArtist ascending: YES];
	NSSortDescriptor * sortDescriptorAlbum = [NSSortDescriptor sortDescriptorWithKey:keyAlbum ascending: YES];
	NSSortDescriptor * sortDescriptorTitle = [NSSortDescriptor sortDescriptorWithKey:keyTitle ascending: YES];
	
	NSArray * sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, sortDescriptorArtist, sortDescriptorAlbum, sortDescriptorTitle, nil];
	
	files = [files sortedArrayUsingDescriptors:sortDescriptors];
	
	 return files;
}

- (void) updateSearch
{
	if (! needsSearched || ! [search length]) return;
	needsSearched = NO;
	
	NSArray * toBeSearched;
	
	if ([search rangeOfString:oldSearch].location != NSNotFound) // If the new search contains the old one then use old results as a start
	{
		toBeSearched = [NSArray arrayWithArray:searchMembers];
	} else {
		toBeSearched = [NSArray arrayWithArray:members];
	}
	
	NSArray * searchSet = [search componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[searchMembers release];
	searchMembers = [[NSMutableArray alloc] init];
	
	BOOL add;
	for (LFile * f in toBeSearched)
	{
		add = NO;
		for (NSString * attribute in searchSet)
		{
			if (! [attribute length]) continue;
			NSString * searchAttributes = [f searchAttributes];
			if ([searchAttributes rangeOfString:attribute].location != NSNotFound)
			{
				add = YES;
			}
			if (add) continue;
		}
		if (add)
		{
			[searchMembers addObject:f];
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
	[playlist setSort:kTITLE];
	
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
	[playlist setSort:kTITLE];
	
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
		[members addObject:file];
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
		[members removeObject:file];
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

- (void) setSort:(NSString *)newSort
{
	if ([sort isEqualToString:newSort])
	{
		descending = ! descending;
	}
	sort = [newSort retain];
	needsSorted = YES;
}
@end
