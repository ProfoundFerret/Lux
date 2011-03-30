//
//  LFile.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LFile.h"
#import "LFileController.h"
#import "LExtension.h"
#import "LMetadataController.h"
#import "LPlaylist.h"
#import "LPlaylistController.h"
#import "LPlayerController.h"
#import "Lux.h"


@implementation LFile
@synthesize url, attributes, extension;
- (id)init
{
    self = [super init];
    if (self) {
		url = [[NSURL alloc] init];
		attributes = [[NSMutableDictionary alloc] init];
		extension = @"";
		
		[attributes setObject:[NSDate date] forKey:kADD_DATE];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	url = [[aDecoder decodeObjectForKey:kURL] retain];
	attributes = [[aDecoder decodeObjectForKey:kATTRIBUTES] retain];
	searchAttributes = [[aDecoder decodeObjectForKey:kSEARCHATTRIBUTES] retain];
	extension = [[aDecoder decodeObjectForKey:kEXTENSION] retain];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:url forKey:kURL];
	[aCoder encodeObject:attributes forKey:kATTRIBUTES];
	[aCoder encodeObject:searchAttributes forKey:kSEARCHATTRIBUTES];
	[aCoder encodeObject:extension forKey:kEXTENSION];
}

- (void)dealloc
{
	[url release];
	[attributes release];
	if (searchAttributes) [searchAttributes release];
	
    [super dealloc];
}

- (NSString *) extension
{
	if (! [extension length]) 
	{	
		extension = [[[url pathExtension] lowercaseString] retain];
	}
	return extension;
}

- (NSString *) searchAttributes
{	
	if (searchAttributes && [searchAttributes length])
	{
		return searchAttributes;
	}
	
	NSMutableArray * newSearchAttributes = [NSMutableArray array];
	NSArray * attrList = [NSArray arrayWithObjects:kTITLE,kARTIST,kALBUM,nil];
	NSString * attribute;
	NSString * attr;
	for (attr in attrList)
	{
		attribute = [attributes objectForKey:attr];
		if (attribute) { attribute = [attribute lowercaseString]; }
		if ([attribute length]) [newSearchAttributes addObject:attribute];
	}
	searchAttributes = [[newSearchAttributes componentsJoinedByString:@" "] retain];
	return searchAttributes;
}

- (id) attributeForIdentifier: (id) identifier
{
	id attribute = [[self dictionary] objectForKey:identifier];
	if (attribute) return attribute;
	return @"";
}

- (NSDictionary *) dictionary
{
	if (dictionary) return dictionary;
	
	register NSMutableDictionary * _dictionary = [[NSMutableDictionary alloc] initWithDictionary:attributes];
	[_dictionary setObject:[NSNumber numberWithInt:[self fileType]] forKey:kFILE_TYPE];
	[_dictionary setObject:url forKey:kURL];
	dictionary = _dictionary;
	
	return [self dictionary];
}

- (LFileType) fileType
{
	LFileController * fc = [LFileController sharedInstance];
	
	LFileType fileType = [fc fileTypeForFile:self];
	
	return fileType;
}

- (void) updateMetadata
{
	[[LMetadataController sharedInstance] parseMetadataForFile:self];
	
	searchAttributes = [NSString string];
	[self searchAttributes];
	
	dictionary = nil;
}

- (NSArray *) playlists
{
	NSMutableArray * playlists = [NSMutableArray array];
	for (LPlaylist * playlist in [[LPlaylistController sharedInstance] getPlaylists])
	{
		if ([[playlist allMembers] containsObject:self]) [playlists addObject:playlist];
	}
	return [NSArray arrayWithArray:playlists];
}

- (NSArray *) notPlaylists
{
	NSMutableArray * playlists = [NSMutableArray array];
	for (LPlaylist * playlist in [[LPlaylistController sharedInstance] getPlaylists])
	{
		if (! [[playlist allMembers] containsObject:self]) [playlists addObject:playlist];
	}
	return [NSArray arrayWithArray:playlists];
}
@end
