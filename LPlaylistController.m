//
//  LPlaylistController.m
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylistController.h"
#import "Lux.h"

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
	
	playlists = [aDecoder decodeObjectForKey:kPLAYLISTS];
	activePlaylist = [aDecoder decodeObjectForKey:kACTIVE_PLAYLIST];
	
	return [self retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{	
	[aCoder encodeObject:playlists forKey:kPLAYLISTS];
	[aCoder encodeObject:activePlaylist forKey:kACTIVE_PLAYLIST];
}

- (void) setupLibraryPlaylists
{
	playlists = [[NSMutableDictionary alloc] init];
	
	NSMutableArray * library = [self getPlaylistsFromGroup:kLIBRARY];
	
	[library addObject:[LPlaylist musicPlaylist]];
	[library addObject:[LPlaylist videoPlaylist]];
}

- (void) addPlaylist: (LPlaylist *) playlist
{
	[self addPlaylist:playlist toGroupNamed:kPLAYLISTS];
}

- (void) addPlaylist: (LPlaylist *) playlist toGroupNamed:(NSString *) name
{
	NSMutableArray * playlistGroup = [self getPlaylistsFromGroup:name];
	[playlistGroup addObject:playlist];
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
	[[self activePlaylist] setSearch:search];
	[[Lux sharedInstance] reloadData];
}
@end
