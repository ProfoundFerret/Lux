//
//  LPlaylistController.m
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylistController.h"
#import "Lux.h"
#import "NSStringCategory.h"

#define kDUPLICATE_TEXT @"Duplicate"
#define kDELETE_TEXT @"Delete"
#define kCONVERT_TO_REGULAR_PLAYLIST_TEXT @"Convert to Regular Playlist"
#define kRENAME_TEXT @"Rename"

#define controller [LFileController sharedInstance]

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
	
	// Don't reloadData if it's the same playlist; reloadData will be run anyways when the new playlist is auto selected
	if (playlist != activePlaylist) 
	{
		[[Lux sharedInstance] reloadData];
	}
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
	[[NSNotificationCenter defaultCenter] postNotificationName:kBEGIN_EDITING_PLAYLIST_NOTIFICATION object:newPlaylist];
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

- (void) renamePlaylistByMenuItem: (NSMenuItem *) menuItem
{
	[[NSNotificationCenter defaultCenter] postNotificationName:kBEGIN_EDITING_PLAYLIST_NOTIFICATION object:[menuItem representedObject]];
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
		NSMenuItem * rename = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:rename];
		[rename setTitle:kRENAME_TEXT];
		[rename setAction:@selector(renamePlaylistByMenuItem:)];
		[rename setTarget:self];
		[rename setRepresentedObject:playlist];

		[menu addItem:[NSMenuItem separatorItem]];
		NSMenuItem * delete = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:delete];
		[delete setTitle:kDELETE_TEXT];
		[delete setTarget:self];
		[delete setAction:@selector(deletePlaylistByMenuItem:)];
		[delete setRepresentedObject:playlist];
	}
	for (NSMenuItem * menuItem in [[LExtensionController sharedInstance] menuItemsForPlaylist:playlist])
	{
		[menu addItem:menuItem];
	}
	return menu;
}

- (BOOL) shuffle
{
	return [[self activePlaylist] shuffle];
}

- (BOOL) repeat
{
	return [[self activePlaylist] repeat];
}

- (void) setShuffle: (BOOL) shuffle
{
	[[self activePlaylist] setShuffle:shuffle];
}

- (void) setRepeat: (BOOL) repeat
{
	[[self activePlaylist] setRepeat:repeat];
}

- (void) toggleShuffle
{
	[[self activePlaylist] toggleShuffle];
}

- (void) toggleRepeat
{
	[[self activePlaylist] toggleRepeat];
}

- (void) reloadData
{
	[self prepPlaylistsForUpdate];
	[super reloadData];
}

- (void) toggleColumn: (NSString *) column
{
	LPlaylist * playlist = [self visiblePlaylist];
	[playlist toggleColumn:column];
}

- (void) toggleColumnByMenuItem: (NSMenuItem *) menuItem
{
	[self toggleColumn:[menuItem representedObject]];
}

- (NSMenu *) columnMenu
{
	NSMenu * menu = [[NSMenu alloc] init];
	[menu setAutoenablesItems:NO];
	NSArray * columns = [[self visiblePlaylist] columns];
	
	NSArray * attributes = [kKEEPER_ATTRIBUTES sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
	for (NSString * str in attributes)
	{
		NSMenuItem * attribute = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:attribute];
		[attribute setTitle:[str unCamelCasedString]];
		[attribute setTarget:self];
		[attribute setAction:@selector(toggleColumnByMenuItem:)];
		[attribute setRepresentedObject:str];
		if ([columns containsObject:str])
		{
			[attribute setState:NSOnState];
		} else {
			[attribute setState:NSOffState];
		}
		[attribute setEnabled:YES];
	}
	return [menu autorelease];
}

- (void) setActivePlaylist:(LPlaylist *)newActivePlaylist
{
	if (newActivePlaylist == [self activePlaylist]) return;
	activePlaylist = newActivePlaylist;
	[[NSNotificationCenter defaultCenter] postNotificationName:kPLAYLIST_ACTIVE_CHANGED_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSHUFFLE_CHANGED_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] postNotificationName:kREPEAT_CHANGED_NOTIFICATION object:nil];
}

- (void) setVisiblePlaylist:(LPlaylist *)newVisiblePlaylist
{
	if (newVisiblePlaylist == [self visiblePlaylist]) return;
	visiblePlaylist = newVisiblePlaylist;
	[[NSNotificationCenter defaultCenter] postNotificationName:kPLAYLIST_VISIBLE_CHANGED_NOTIFICATION object:nil];
}
@end
