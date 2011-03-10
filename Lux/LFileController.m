//
//  LFileController.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LFileController.h"

@implementation LFileController

- (id)init
{
    self = [super init];
    if (self) {
		files = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[files dealloc];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	files = [[aDecoder decodeObjectForKey:kFILES] retain];
	
	return [self retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:files forKey:kFILES];
	
	[super encodeWithCoder:aCoder];
}

- (NSDictionary *) files
{
	return [NSDictionary dictionaryWithDictionary:files];
}

- (LFile *) createFileByURL: (NSURL *) url;
{
	LFile * f = [[LFile alloc] init];
	[f setUrl:url];
	
	return [f autorelease];
}

- (BOOL) addFileByFile: (LFile *) file
{
	if (! file) return NO;
	if ([files objectForKey:[file url]]) return NO;
	if ([file fileType] == LFileTypeUnknown) return NO;
	
	[files setObject:file forKey:[file url]];
	
	return YES;
}

- (void) addFilesByURL: (NSArray *) fileURLs
{
	for (NSURL * url in fileURLs)
	{
		[self addFileByURL:url];
	}
}

- (void) addFileByURL: (NSURL *) url
{
	LFile * f = [[self createFileByURL:url] retain];
	[self addFileByFile:f];
}
@end
