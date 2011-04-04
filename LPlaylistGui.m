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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renamePlaylistByNotification:) name:kBEGIN_EDITING_PLAYLIST_NOTIFICATION object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kPLAYLIST_VISIBLE_CHANGED_NOTIFICATION object:nil];
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
	[playlistList registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, nil]];
	
	[searchField setTarget:self];
	[searchField setAction:@selector(searchChanged)];
	
	[addPlaylistButton setTarget:self];
	[addPlaylistButton setAction:@selector(addPlaylist)];
	
	[searchMenuItem setTarget:self];
	[searchMenuItem setAction:@selector(selectSearchField)];
	
	[newPlaylistMenuItem setTarget:self];
	[newPlaylistMenuItem setAction:@selector(addPlaylist)];
	
	[self reloadData];
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
		[newTitle autorelease];
	}
}

- (void) outlineViewSelectionDidChange:(NSNotification *)notification
{
	NSInteger row = [playlistList selectedRow];
	id item = [playlistList itemAtRow:row];
	[controller setVisiblePlaylist:item];
	[searchField setStringValue:[item search]];
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	return (! [item isKindOfClass:[NSString class]]);
}

- (BOOL) outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
	return (! [self outlineView:outlineView isGroupItem:item]);
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

- (NSDragOperation) outlineView:(NSOutlineView *)outlineView validateDrop:(id<NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)index
{
	NSPasteboard * pboard = [info draggingPasteboard];

	if ([item isKindOfClass:[LPlaylist class]])
	{
		NSArray * urlStrings = [pboard propertyListForType:NSFilenamesPboardType];
		NSMutableArray * urls = [NSMutableArray array];
		
		for (NSString * urlString in urlStrings)
		{
			[urls addObject:[NSURL fileURLWithPath:urlString]];
		}
		
		return [item dragOperationForURLs:urls];
	} else if (item)
	{
		if ([item isEqualToString:kPLAYLISTS])
		{
			return NSDragOperationCopy;
		}
	}
	return NSDragOperationNone;
}

- (BOOL) outlineView:(NSOutlineView *)outlineView acceptDrop:(id<NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)index
{
	NSPasteboard * pboard = [info draggingPasteboard];
	NSArray * urlStrings = [pboard propertyListForType:NSFilenamesPboardType];
	NSMutableArray * urls = [NSMutableArray array];
	
	NSMutableArray * files = [NSMutableArray array];
	
	for (NSString * urlString in urlStrings)
	{
		NSURL * url = [NSURL fileURLWithPath:urlString];
		[urls addObject:url];
	}
	
	[[LFileController sharedInstance] unblacklistURLs:urls];
	[[LFileController sharedInstance] addFilesByURL:urls];
	
	for (NSURL * url in urls)
	{
		[files addObject:[[[LFileController sharedInstance] files] objectForKey:url]];
	}
	
	if ([item isKindOfClass:[LPlaylist class]])
	{
		[item addFiles:files];
	} else {
		[controller addFilesToNewPlaylist:files];
	}
	
	return YES;
}

- (void) searchChanged
{
	[controller searchChangedTo: [searchField stringValue]];
}

- (void) reloadData
{
	[playlistList reloadData];
	[self selectVisiblePlaylist];
}

- (void) selectPlaylist: (LPlaylist *) playlist
{
	[playlistList expandItem:nil expandChildren:YES];
	[playlistList selectItem:playlist];
}

- (void) selectVisiblePlaylist
{
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	[self selectPlaylist:visiblePlaylist];
}

- (void) addPlaylist
{
	LPlaylist * playlist = [[[LPlaylist alloc] init] autorelease];
	
	[controller addPlaylist: playlist];
	
	[[Lux sharedInstance] reloadData];
	
	[self renamePlaylist: playlist];
}

- (void) renamePlaylistByNotification: (NSNotification *) notification
{
	[self renamePlaylist:[notification object]];
}

- (void) renamePlaylist: (LPlaylist *) playlist
{
	[self selectPlaylist:playlist];
	
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
	return menu;
}
@end