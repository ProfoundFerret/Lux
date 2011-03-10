//
//  LPlaylist.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylist.h"
#import "LFile.h"
#import "LExtension.h"
#import "LFileController.h"
#import "LExtension.h"

#define kMUSIC @"Music"
#define kVIDEO @"Video"

@implementation LPlaylist
@synthesize title, needsUpdated, columns, smart, predicate, search, write;
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
		title = @"";
		search = @"";
		oldSearch = @"";
		predicate = @"";
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
	
	[super encodeWithCoder:aCoder];
}

- (void) update
{
	@synchronized(self)
	{
		//if (! needsUpdated || ! smart) return;
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

- (NSMutableDictionary *) members
{
	[self update];
	if ([search length]) return [self searchMembers];
	return members;
}

- (NSMutableDictionary *) searchMembers
{
	if (! needsSearched) return searchMembers;
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
	return searchMembers;
}

-(void) setSearch:(NSString *) aSearch
{
	needsSearched = YES;
	oldSearch = search;
	search = [[aSearch lowercaseString] retain];
	if (! [search length]) [searchMembers release];
}

+ (LPlaylist *) musicPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	NSString * predicate = [[NSString alloc] initWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeAudio];
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	[playlist setTitle:kMUSIC];
	
	[playlist setWrite:NO];
	
	return playlist;
}

+ (LPlaylist *) videoPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	NSString * predicate = [[NSString alloc] initWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeVideo];
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	[playlist setTitle:kVIDEO];
	
	
	[playlist setWrite:NO];
	
	return playlist;
}
@end
