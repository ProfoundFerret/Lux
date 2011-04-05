//
//  LExtensionController.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LExtensionController.h"
#import	"LExtension.h"
#import "LDefinitions.h"

//
#import "LInputOutput_Computer.h"
#import "LPlayer_QTKit.h"
#import "LMetadata_MP3.h"
//

@implementation LExtensionController
@synthesize extensions;
- (id)init
{
    self = [super init];
    if (self) {
		extensions = [[NSMutableArray alloc] init];
		
		[self loadDefaultExtensions];
    }
    
    return self;
}

- (void) loadDefaultExtensions
{
	[self addExtension: [[LInputOutput_Computer alloc] init]];
	[self addExtension: [[LPlayer_QTKit alloc] init]];
	[self addExtension: [[LMetadata_MP3 alloc] init]];
}

- (void)dealloc
{
	[extensions dealloc];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	extensions = [[aDecoder decodeObjectForKey:kEXTENSIONS] retain];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:extensions forKey:kEXTENSIONS];
	
	[super encodeWithCoder:aCoder];
}

- (BOOL) addExtension: (LExtension *) extension
{
	if ([extensions containsObject:extension]) return NO;
	[extensions addObject:extension];
	return YES;
}

- (NSArray *) extensionsMatchingDelegate: (Protocol *) protocol
{
	NSMutableArray * exts = [NSMutableArray array];
	for (LExtension * ext in extensions)
	{
		if ([[ext class] conformsToProtocol:protocol]) [exts addObject:ext];
	}
	return [NSArray arrayWithArray:exts];
}

- (NSArray *)menuItemsForFiles:(NSArray *)files
{
	NSMutableArray * menuItems = [NSMutableArray array];
	for (LExtension * ext in extensions)
	{
		[menuItems addObjectsFromArray:[ext menuItemsForFiles:files]];
	}
	 return menuItems;
}

- (NSArray *) menuItemsForPlaylist:(LPlaylist *)playlist
{
	NSMutableArray * menuItems = [NSMutableArray array];
	for (LExtension * ext in extensions)
	{
		[menuItems addObjectsFromArray:[ext menuItemsForPlaylist:playlist]];
	}
	return menuItems;	
}

@end
