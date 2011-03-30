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
#import "LPlaylist.h"

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
	
	[addPlaylistButton setTarget:self];
	[addPlaylistButton setAction:@selector(addPlaylist)];
	
	[searchMenuItem setTarget:self];
	[searchMenuItem setAction:@selector(selectSearchField)];
	
	[newPlaylistMenuItem setTarget:self];
	[newPlaylistMenuItem setAction:@selector(addPlaylist)];
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
		return [[(NSDictionary *) [controller playlists] allKeys] objectAtIndex:index];
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
	
	[[Lux sharedInstance] reloadData];

}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return (! [item isKindOfClass:[NSString class]]);
}

- (void) outlineView:(NSOutlineView *)outlineView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
	if ([item isKindOfClass:[LPlaylist class]])
	{
		[item setTitle:[object retain]];
	}
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
	if ([item isKindOfClass:[LPlaylist class]])
	{
		return [item write];
	}
	return NO;
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

- (void) addPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	[controller addPlaylist: playlist];
	
	[[Lux sharedInstance] reloadData];
	
	[self renamePlaylist: playlist];
}

- (void) renamePlaylist: (LPlaylist *) playlist
{
	[playlistList expandItem:nil expandChildren:YES];
	[playlistList selectItem:playlist];
	
	NSInteger fileRow = [playlistList rowForItem:playlist];
	
	[playlistList editColumn:0 row:fileRow withEvent:nil select:YES];
}

- (void) renamePlaylistByMenuItem: (NSMenuItem *) menuItem
{
	LPlaylist * playlist = [menuItem representedObject];
	[self renamePlaylist:playlist];
}

- (void) selectSearchField
{
	[searchField selectText:nil];
}

- (NSMenu *) menuForEvent: (NSEvent *) event
{
	NSPoint where = [playlistList convertPoint:[event locationInWindow] fromView:nil];
	NSInteger row = [playlistList rowAtPoint:where];
	
	if (row < 0) return nil;
	
	LPlaylist * playlist = [playlistList itemAtRow:row];
	
	NSMenu * menu = [[LPlaylistController sharedInstance] menuForPlaylist: playlist];
	
	if ([playlist write])
	{
		NSMenuItem * rename = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:rename];
		[rename setTitle:kRENAME_TEXT];
		[rename setAction:@selector(renamePlaylistByMenuItem:)];
		[rename setTarget:self];
		[rename setRepresentedObject:playlist];
	}
	
	return menu;
}
@end