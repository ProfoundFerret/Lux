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
		fileType = LFileTypeUnknown;
		
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
	fileType = [aDecoder decodeIntForKey:kFILE_TYPE];
	
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:url forKey:kURL];
	[aCoder encodeObject:attributes forKey:kATTRIBUTES];
	[aCoder encodeObject:[self searchAttributes] forKey:kSEARCHATTRIBUTES];
	[aCoder encodeObject:[self extension] forKey:kEXTENSION];
	[aCoder encodeInt:[self fileType] forKey:kFILE_TYPE];
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
	searchAttributes = [[[newSearchAttributes componentsJoinedByString:@" "] lowercaseString] retain];
	return searchAttributes;
}

- (id) formatedAttributeForIdentifier: (id) identifier
{
	id attribute = [[self dictionary] objectForKey:identifier];
	if ([attribute isKindOfClass:[NSDate class]])
	{
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
		attribute = [dateFormatter stringFromDate:attribute];
	} else if ([identifier isEqualToString:kRATING])
	{
		float rating = [attribute floatValue];
		NSMutableString * stars = [NSMutableString string];
		
		while (rating)
		{
			if (rating >= 1)
			{
				[stars appendString:kSTAR];
				rating -= 1;
			} else {
				[stars appendString:kHALF_STAR];
				rating -= 0.5;
			}
		}
		
		attribute = stars;
	} else if ([identifier isEqualToString:kTIME])
	{
		NSUInteger seconds;
		NSUInteger minutes;
		NSUInteger hours;
		
		NSUInteger time = [attribute intValue] / 1000;
		
		hours = time / 3600;
		minutes = (time / 60) % 60;
		seconds = time % 60;
		
		NSMutableString * string = [NSMutableString string];
		
		if (hours)
		{
			string = [NSString stringWithFormat:@"%u:%02u:%02u", hours, minutes, seconds];
		} else {
			string = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
		}
		
		attribute = string;
		
	}
	if (attribute) return attribute;
	return @"";
}

- (void) resetCachedData
{
	dictionary = nil;
	lowercaseDictionary = nil;
	searchAttributes = nil;
}

- (NSDictionary *) dictionary
{
	if (dictionary) return dictionary;
	
	register NSMutableDictionary * _dictionary = [[NSMutableDictionary alloc] initWithDictionary:attributes];
	[_dictionary setObject:[NSNumber numberWithInt:[self fileType]] forKey:kFILE_TYPE];
	[_dictionary setObject:url forKey:kURL];
	[_dictionary setObject:[self extension] forKey:kEXTENSION];

	dictionary = _dictionary;
	
	lowercaseDictionary = nil;
	
	return dictionary;
}

- (NSDictionary *) lowercaseDictionary
{
	if (lowercaseDictionary) return lowercaseDictionary;
	
	lowercaseDictionary = [[NSMutableDictionary alloc] init];
	
	for (NSString * str in [self dictionary])
	{
		id obj = [[self dictionary] objectForKey:str];
		if ([obj isKindOfClass:[NSString class]])
		{
			obj = [[obj lowercaseString] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
		}
		[lowercaseDictionary setObject:obj forKey:str];
	}
	
	return lowercaseDictionary;
}

- (LFileType) fileType
{
	if (fileType != LFileTypeUnknown) return fileType;
	
	fileType = [[LFileController sharedInstance] fileTypeForFile:self];
	
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
