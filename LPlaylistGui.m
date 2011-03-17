//
//  LPlaylistGui.m
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlaylistGui.h"
#import "Lux.h"
#import "LPlaylistController.h"

#import "NSOutlineView+Lux.h"

#define controller [LPlaylistController sharedInstance]

@implementation LPlaylistGui
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) awakeFromNib
{
	[controller addGui:self];
	
	[playlistList setTarget:self];
	[playlistList setDataSource:self];
	[playlistList setDelegate:self];
	[playlistList expandItem:nil expandChildren:YES];
	[playlistList selectItem:[controller visiblePlaylist]];
	
	[searchField setTarget:self];
	[searchField setAction:@selector(searchChanged)];
}

- (NSInteger) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
	if (item == nil)
	{
		return [[controller playlists] count];
	} else {
		return [[controller getPlaylistsFromGroup:item] count];
	}
}

- (BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
	return ([item isKindOfClass:[NSString class]]);
}

- (id) outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
	if (item == nil)
	{
		return [[[controller playlists] allKeys] objectAtIndex:index];
	} else {
		return [[controller getPlaylistsFromGroup:item] objectAtIndex:index];
	}
}

- (id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if ([item isKindOfClass:[NSString class]])
	{
		return item;
	} else {
		return [item title];
	}
}

- (BOOL) outlineView: (NSOutlineView *) sender isGroupItem:(id)item
{
	return ([item isKindOfClass:[NSString class]]);
}

- (void) outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if ([item isKindOfClass:[NSString class]])
	{
		NSMutableAttributedString *newTitle = [[cell attributedStringValue] mutableCopy];
		[newTitle replaceCharactersInRange:NSMakeRange(0,[newTitle length]) withString:[[newTitle string] uppercaseString]];
		[cell setAttributedStringValue:newTitle];
		[newTitle release];
	}
}

- (void) outlineViewSelectionDidChange:(NSNotification *)notification
{
	NSInteger row = [playlistList selectedRow];
	id item = [playlistList itemAtRow:row];
	[controller setVisiblePlaylist:item];
	[searchField setStringValue:[item search]];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"visiblePlaylistChanged" object:visiblePlaylist];
	
	[[Lux sharedInstance] reloadData];
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return (! [item isKindOfClass:[NSString class]]);
}

- (LPlaylist *) visiblePlaylist
{
	if (! visiblePlaylist)
	{
		visiblePlaylist = [controller activePlaylist];
	}
	return visiblePlaylist;
}

- (void) searchChanged
{
	[controller searchChangedTo: [searchField stringValue]];
}

- (void) reloadData
{
	[playlistList reloadData];
}
@end
