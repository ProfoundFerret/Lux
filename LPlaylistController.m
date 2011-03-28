//
//  LPlaylistController.m
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylistController.h"
#import "Lux.h"

#define kDUPLICATE_TEXT @"Duplicate"
#define kDELETE_TEXT @"Delete"
#define kCONVERT_TO_REGULAR_PLAYLIST_TEXT @"Convert to Regular Playlist"

@implementation LPlaylistController
@synthesize activePlaylist, playlists, visiblePlaylist;

- (id)init
{
    self = [super init];
    if (self) {
		[self setupLibraryPlaylists];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	playlists = [[aDecoder decodeObjectForKey:kPLAYLISTS] retain];
	activePlaylist = [[aDecoder decodeObjectForKey:kACTIVE_PLAYLIST] retain];
	visiblePlaylist = [[aDecoder decodeObjectForKey:kVISIBLE_PLAYLIST] retain];
	
	return [self retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:playlists forKey:kPLAYLISTS];
	[aCoder encodeObject:activePlaylist forKey:kACTIVE_PLAYLIST];
	[aCoder encodeObject:visiblePlaylist forKey:kVISIBLE_PLAYLIST];
}

- (void) setupLibraryPlaylists
{
	playlists = [[NSMutableDictionary alloc] init];
	NSMutableArray * library = [self getPlaylistsFromGroup:kLIBRARY];
	[library removeAllObjects];
	
	[library addObject:[LPlaylist musicPlaylist]];
	[library addObject:[LPlaylist videoPlaylist]];
	[library addObject:[LPlaylist streamingPlaylist]];
	
	[self getPlaylists];
}

- (void) addPlaylist: (LPlaylist *) playlist
{
	[self addPlaylist:playlist toGroupNamed:kPLAYLISTS];
}

- (void) removePlaylist:(LPlaylist *)playlist
{
	if (! [playlist write]) return;
	[self removePlaylist:playlist fromGroupNamed:kPLAYLISTS];
}

- (void) addPlaylist: (LPlaylist *) playlist toGroupNamed:(NSString *) name
{
	NSMutableArray * playlistGroup = [self getPlaylistsFromGroup:name];
	[playlistGroup addObject:playlist];
}

- (void) removePlaylist:(LPlaylist *)playlist fromGroupNamed:(NSString *)name
{
	NSMutableArray * playlistGroup = [self getPlaylistsFromGroup:name];
	[playlistGroup removeObject:playlist];
	
	[[Lux sharedInstance] reloadData];
}

- (NSMutableArray *) getPlaylists
{
	return [self getPlaylistsFromGroup:kPLAYLISTS];
}

- (NSMutableArray *) getPlaylistsFromGroup: (NSString *) name
{
	if (! [playlists objectForKey:name])
	{
		[playlists setObject:[NSMutableArray array] forKey:name];
	}
	return [playlists objectForKey:name];
}

- (NSMutableArray *) allPlaylists
{
	NSMutableArray * plists = [NSMutableArray array];
	for (NSString * arrayName in playlists)
	{
		NSArray * array = [playlists objectForKey:arrayName];
		for (LPlaylist * p in array)
		{
			[plists addObject:p];
		}
	}
	return plists;
}

- (void) prepPlaylistsForUpdate
{
	for (LPlaylist * p in [self allPlaylists])
	{
		[p setNeedsUpdated:YES];
	}
}

- (LPlaylist *) activePlaylist
{
	if (activePlaylist == nil)
	{
		activePlaylist = [[self getPlaylistsFromGroup:kLIBRARY] objectAtIndex:0];
	}
	return activePlaylist;
}

- (LPlaylist *) visiblePlaylist
{
	if (visiblePlaylist == nil)
	{
		visiblePlaylist = [self activePlaylist];
	}
	return visiblePlaylist;
}

- (void) searchChangedTo: (NSString *) search
{
	[[self visiblePlaylist] setSearch:search];
	[[Lux sharedInstance] reloadData];
}

- (void) duplicatePlaylist:(LPlaylist *)playlist
{
	LPlaylist * duplicatedPlaylist = [playlist copy];
	
	[self addPlaylist:duplicatedPlaylist];
	
	[[Lux sharedInstance] reloadData];
}

- (void) convertToRegularPlaylist:(LPlaylist *)playlist
{
	if (! [playlist write] || ! [playlist smart]) return;
	
	[playlist setSmart:NO];
	
	[[Lux sharedInstance] reloadData];
}

- (void) addFilesToNewPlaylist: (NSArray *) files
{
	LPlaylist * newPlaylist = [[LPlaylist alloc] init];
	[newPlaylist addFiles:files];
	[self addPlaylist:newPlaylist];
	[[Lux sharedInstance] reloadData];
}

- (void) addFilesToNewPlaylistByMenuItem: (NSMenuItem *) menuItem
{
	NSArray * newFiles = [menuItem representedObject];
	[self addFilesToNewPlaylist: newFiles];
}

- (void) dupliatePlaylistByMenuItem: (NSMenuItem *) menuItem
{
	LPlaylist * playlist = [menuItem representedObject];
	[self duplicatePlaylist:playlist];
}

- (void) deletePlaylistByMenuItem: (NSMenuItem *) menuItem
{
	LPlaylist * playlist = [menuItem representedObject];
	
	[self removePlaylist:playlist];
}

- (void) convertToRegularPlaylistByMenuItem: (NSMenuItem *) menuItem
{
	LPlaylist * playlist = [menuItem representedObject];
	
	[self convertToRegularPlaylist:playlist];
}

- (NSMenu *) menuForPlaylist: (LPlaylist *) playlist
{
	NSMenu * menu = [[[NSMenu alloc] init] autorelease];
	[menu setAutoenablesItems:NO];
	
	NSMenuItem * duplicate = [[[NSMenuItem alloc] init] autorelease];
	[menu addItem:duplicate];
	[duplicate setTitle:kDUPLICATE_TEXT];
	[duplicate setTarget:self];
	[duplicate setAction:@selector(dupliatePlaylistByMenuItem:)];
	[duplicate setRepresentedObject:playlist];
	
	if ([playlist write] && [playlist smart])
	{
		NSMenuItem * convertToRegular = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:convertToRegular];
		[convertToRegular setTitle:kCONVERT_TO_REGULAR_PLAYLIST_TEXT];
		[convertToRegular setTarget:self];
		[convertToRegular setAction:@selector(convertToRegularPlaylistByMenuItem:)];
		[convertToRegular setRepresentedObject:playlist];
	}
	
	if ([playlist write])
	{
		[menu addItem:[NSMenuItem separatorItem]];
		NSMenuItem * delete = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:delete];
		[delete setTitle:kDELETE_TEXT];
		[delete setTarget:self];
		[delete setAction:@selector(deletePlaylistByMenuItem:)];
		[delete setRepresentedObject:playlist];
	}
	
	return menu;
}

- (void) reloadData
{
	[self prepPlaylistsForUpdate];
	[super reloadData];
}
@end
