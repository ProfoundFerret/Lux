//
//  LMetadataController.m
//  Lux
//
//  Created by Kyle Carson on 3/15/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LMetadataController.h"
#import "LExtensionController.h"
#import "LDefinitions.h"

@implementation LMetadataController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) parseMetadataForFile: (LFile *) file
{
	NSString * ext = [file extension];
	NSMutableDictionary * newAttributes = [NSMutableDictionary dictionary];
	for (LExtension <LMetadataDelegate> * extension in [self extensions])
	{
		for (NSString * fileExt in [extension supportedMetadataExtensions])
		{
			if ([fileExt isEqualToString:ext])
			{
				NSDictionary * metaData = [extension metadataForURL:[file url]];
				if (metaData)
				{
					[newAttributes addEntriesFromDictionary:metaData];
				}
			}
		}
	}
	
	for (NSString * attr in newAttributes)
	{
		if ([kKEEPER_ATTRIBUTES containsObject:attr] || [[attr substringToIndex:0] isEqualToString:@"_"])
		{
			[[file attributes] setObject:[newAttributes objectForKey:attr] forKey:attr];
		}
	}
	
	if (! [[file attributes] objectForKey:kTITLE])
	{
		NSString * title = [[file url] lastPathComponent];
		NSString * ext = [[file url] pathExtension];
		if ([ext length])
		{
			title = [title substringToIndex:([title length] - ([ext length] + 1))];
		}
		[[file attributes] setObject:title forKey:kTITLE];
	}
}

- (NSArray *) extensions
{
	return [[LExtensionController sharedInstance] extensionsMatchingDelegate:@protocol(LMetadataDelegate)];
}
@end
