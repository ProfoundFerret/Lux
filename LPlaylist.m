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

@implementation LPlaylist
@synthesize title, needsUpdated, columns, smart, predicate;
- (id)init
{
    self = [super init];
    if (self) {
		needsUpdated = YES;
		needsSearched = YES;
		members = [[NSMutableDictionary alloc] init];
		searchMembers = [[NSMutableDictionary alloc] init];
		columns = [[NSArray alloc] initWithObjects:kINDEX, kTITLE, kARTIST, kALBUM, nil];
		title = @"";
		search = @"";
		oldSearch = @"";
		predicate = @"";
		
		smart = NO;
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
	members = [aDecoder decodeObjectForKey:kMEMBERS];
	title = [[aDecoder decodeObjectForKey:kPLAYLIST_TITLE] retain];
	search = [[aDecoder decodeObjectForKey:kSEARCH] retain];
	smart = [[aDecoder decodeObjectForKey:kSMART] boolValue];
	predicate = [[aDecoder decodeObjectForKey:kPREDICATE] retain];
	
	needsSearched = YES;
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:members forKey:kMEMBERS];
	[aCoder encodeObject:title forKey:kTITLE];
	[aCoder encodeObject:search forKey:kSEARCH];
	[aCoder encodeObject:[NSNumber numberWithInt:smart] forKey:kSMART];
	[aCoder encodeObject:predicate forKey:kPREDICATE];
	
	[super encodeWithCoder:aCoder];
}

- (void) update
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
}

+ (LPlaylist *) musicPlaylist
{
	LPlaylist * playlist = [[LPlaylist alloc] init];
	
	NSString * predicate = [[NSString alloc] initWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeAudio];
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	
	NSLog(@"%@",[playlist members]);
	
	return playlist;
}

+ (LPlaylist *) videoPlaylist
{
	LPlaylist * playlist = [[LPlaylist alloc] init];
	
	NSString * predicate = [[NSString alloc] initWithFormat:@"%@ = %d", kFILE_TYPE, LFileTypeVideo];
	[playlist setPredicate:predicate];
	[playlist setSmart:YES];
	
	return playlist;
}
@end