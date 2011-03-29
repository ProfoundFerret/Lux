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
		searchAttributes = [[NSArray alloc] init];
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
	[aCoder encodeObject:[self searchAttributes] forKey:kSEARCHATTRIBUTES];
	[aCoder encodeObject:[self extension] forKey:kEXTENSION];
}

- (void)dealloc
{
	[url release];
	[attributes release];
	[searchAttributes release];
	
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

- (NSArray *) searchAttributes
{	
	if ([searchAttributes count]) return searchAttributes;
	
	NSMutableArray * newsearchAttributes = [NSMutableArray array];
	NSArray * attrList = [NSArray arrayWithObjects:kTITLE,kARTIST,kALBUM,nil];
	
	for (NSString * attr in attrList)
	{
		NSString * attribute = [attributes objectForKey:attr];
		if (attribute) { attribute = [[attribute lowercaseString] retain]; };
		if (attribute && [attribute length]) [newsearchAttributes addObject:attribute];
	}
	return searchAttributes;
}

- (id) attributeForIdentifier: (id) identifier
{
	id attribute = [attributes objectForKey:identifier];
	if (attribute) return attribute;
	return @"";
}

- (NSDictionary *) dictionary
{
	if (dictionary) return [NSDictionary dictionaryWithDictionary:dictionary];
	
	dictionary = [[NSMutableDictionary alloc] initWithDictionary:attributes];
	[dictionary setObject:[NSNumber numberWithInt:[self fileType]] forKey:kFILE_TYPE];
	[dictionary setObject:url forKey:kURL];
	
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
	
	searchAttributes = [[NSArray alloc] init];
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
		if (! [[playlist allMembers] containsObject:[self url]]) [playlists addObject:playlist];
	}
	return [NSArray arrayWithArray:playlists];
}
@end
