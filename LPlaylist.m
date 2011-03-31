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
	[self update];
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
	@synchronized(self)
	{
		[self update];
		[self updateSort];
		
		NSArray * mList;
		if ([search length])
		{
			[self updateSearch];
			mList = searchMembers;
		} else {
			mList = members;
		}
		return [NSArray arrayWithArray:mList];
	}
}

- (void) update
{
	if (! needsUpdated || ! smart) return;
	needsUpdated = NO;
	needsSearched = YES;
	needsSorted = YES;
	
	oldSearch = nil;
	
	[members autorelease];
	members = [[NSMutableArray alloc] init];
	NSPredicate * pred = [NSPredicate predicateWithFormat:predicate];
	NSMutableDictionary * fileList = [[LFileController sharedInstance] files];
	
	NSURL * url;
	LFile * file;
	
	for (url in fileList)
	{
		file = [fileList objectForKey:url];
		if ( [pred evaluateWithObject:[file dictionary]] )
		{
			[members addObject:file];
		}
	}
}

- (NSString *) createPredicateFromSearch: (NSString *) ss
{
	NSMutableString * smartSearch = [NSMutableString stringWithString:ss];
	
	[smartSearch replaceOccurrencesOfString:@"=" withString:@"=[cd]" options:NSLiteralSearch range:NSMakeRange(0, [smartSearch length])];
	[smartSearch replaceOccurrencesOfString:@"~" withString:@" contains[cd] " options:NSLiteralSearch range:NSMakeRange(0, [smartSearch length])];
	return smartSearch;
}

- (void) preformSmartSearchWithString: (NSString *) string
{
	[searchMembers autorelease];
	searchMembers = [[NSMutableArray alloc] init];
	
	NSString * predString = [self createPredicateFromSearch: search];
	NSPredicate * pred;
	
	@try {
		pred = [NSPredicate predicateWithFormat:predString];
	}
	@catch (NSException *exception) {
		return;
	}
	register LFile * f;
	for (f in [NSArray arrayWithArray:members])
	{
		if ([pred evaluateWithObject:[f dictionary]])
		{
			[searchMembers addObject:f];
		}
	}
}

- (void) updateSearch
{
	if (! needsSearched || ! [search length]) return;
	needsSearched = NO;
	
	register NSArray * toBeSearched;
	
	register NSString * searchAttributes;
	register NSString * attribute;
	
	if (oldSearch && [search rangeOfString:oldSearch].location != NSNotFound) // If the new search contains the old one then use old results as a start
	{
		toBeSearched = [NSArray arrayWithArray:searchMembers];
	} else {
		toBeSearched = [NSArray arrayWithArray:members];
	}
	
	if ([[search substringToIndex:1] isEqualToString:kSMART_SEARCH_DELIMITER])
	{
		[self preformSmartSearchWithString:[search substringFromIndex:1]];
		return;
	}
	register LFile * f;
	
	NSString * normSearch = [search lowercaseString];
	
	NSArray * searchSet = [normSearch componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	[searchMembers release];
	searchMembers = [[NSMutableArray alloc] init];
	
	BOOL add;
	for (f in toBeSearched)
	{
		add = YES;
		for (attribute in searchSet)
		{
			if (! [attribute length]) continue;
			
			searchAttributes = [f searchAttributes];
			if ([searchAttributes rangeOfString:attribute].location == NSNotFound)
			{
				add = NO;
				break;
			}
		}
		if (add) [searchMembers addObject:f];
	}
	
	
	if ([searchMembers count] == 0)
	{
		[self preformSmartSearchWithString:search];
	}
}

- (void) updateSort
{
	if (! needsSorted || ! [members count] || ! sort) return;
	needsSorted = NO;
	
	NSString * key = [NSString stringWithFormat:@"dictionary.%@", sort];
	NSString * keyArtist = [NSString stringWithFormat:@"dictionary.%@", kARTIST];
	NSString * keyAlbum = [NSString stringWithFormat:@"dictionary.%@", kALBUM];
	NSString * keyTitle = [NSString stringWithFormat:@"dictionary.%@", kTITLE];
	
	NSSortDescriptor * sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:! descending];
	NSSortDescriptor * sortDescriptorArtist = [NSSortDescriptor sortDescriptorWithKey:keyArtist ascending: YES];
	NSSortDescriptor * sortDescriptorAlbum = [NSSortDescriptor sortDescriptorWithKey:keyAlbum ascending: YES];
	NSSortDescriptor * sortDescriptorTitle = [NSSortDescriptor sortDescriptorWithKey:keyTitle ascending: YES];
	
	NSArray * sortDescriptors = [NSArray arrayWithObjects:sortDescriptor,sortDescriptorArtist, sortDescriptorAlbum, sortDescriptorTitle, nil];
	
	[members sortUsingDescriptors:sortDescriptors];
	return;
}

- (void) setSearch:(NSString *) aSearch
{
	needsSearched = YES;
	oldSearch = [search retain];
	search = [aSearch retain];
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
		if (! [members containsObject:file])
		{
			[members addObject:file];
		}
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
