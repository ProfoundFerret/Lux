//
//  LFileController.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LFileController.h"
#import	"LPlaylistController.h"
#import "Lux.h"

#define kPLAY_TEXT @"Play"
#define kSHOW_IN_FINDER_TEXT @"Show In Finder"
#define kADD_TO_PLAYLIST_TEXT @"Add To Playlist"
#define kNEW_PLAYLIST @"New Playlist"
#define kDELETE_FROM_TEXT @"Delete From"
#define kDELETE_FROM_LIBRARY_TEXT @"Delete From Library"

@implementation LFileController
@synthesize activeFile, files;
- (id)init
{
    self = [super init];
    if (self) {
		files = [[NSMutableDictionary alloc] init];
		blacklistURLs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[files release];
	[blacklistURLs release];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	files = [[aDecoder decodeObjectForKey:kFILES] retain];
	activeFile = [[aDecoder decodeObjectForKey:kACTIVE_FILE] retain];
	NSMutableArray * _blacklistURLs = [aDecoder decodeObjectForKey:kBLACKLIST_URLS];
	if (_blacklistURLs)
	{
		blacklistURLs = [_blacklistURLs retain];
	} else {
		blacklistURLs = [[NSMutableArray alloc] init];
	}
	
	return [self retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:files forKey:kFILES];
	[aCoder encodeObject:activeFile forKey:kACTIVE_FILE];
	[aCoder encodeObject:blacklistURLs forKey:kBLACKLIST_URLS];
	
	[super encodeWithCoder:aCoder];
}

- (void) blacklistURL:(NSURL *)url
{
	NSArray * array = [NSArray arrayWithObject:url];
	[self blacklistURLS:array];
}

- (void) blacklistURLS: (NSArray *) urls
{
	for (NSURL * url in urls)
	{
		if ([blacklistURLs containsObject:url]) continue;
		[blacklistURLs addObject:url];
		[files removeObjectForKey:url];
	}
	[[Lux sharedInstance] reloadData];
	[self reloadData];
}

- (void) deleteURLSByMenuItem:(NSMenuItem *)menuItem
{
	NSMutableArray * urls = [[NSMutableArray alloc] init];
	for (LFile * file in [menuItem representedObject])
	{
		[urls addObject:[file url]];
	}
	
	[self blacklistURLS:urls];
}

- (LFile *) createFileByURL: (NSURL *) url;
{
	if ([files objectForKey:url]) return [files objectForKey:url];
	LFile * f = [[LFile alloc] init];
	[f setUrl:url];
	
	return [f autorelease];
}

- (BOOL) addFileByFile: (LFile *) file
{
	if (! file) return NO;
	if ([files objectForKey:[file url]]) return NO;
	if ([blacklistURLs containsObject:[file url]]) return NO;
	if ([file fileType] == LFileTypeUnknown) return NO;
	
	[files setObject:file forKey:[file url]];
	[file updateMetadata];
	
	return YES;
}

- (void) addFilesByURL: (NSArray *) fileURLs
{
	for (NSURL * url in fileURLs)
	{
		[self addFileByURL:url];
	}
}

- (BOOL) addFileByURL: (NSURL *) url
{
	LFile * f = [[self createFileByURL:url] retain];
	return [self addFileByFile:f];
}

- (LFileType) fileTypeForFile:(LFile *)file
{
	static NSMutableDictionary * fileTypesForFiles;
	if (! fileTypesForFiles)
	{
		fileTypesForFiles = [[NSMutableDictionary alloc] init];
	}
	NSString * fileExtension = [file extension];
	if (! [fileTypesForFiles objectForKey:fileExtension])
	{
		LExtension <LPlayerDelegate> * player = [[[Lux sharedInstance] playerController] playerForFile:file];
		
		if (player)
		{
			NSNumber * fileType = [NSNumber numberWithInt:[player fileTypeForExtension:fileExtension]];
		
			[fileTypesForFiles setObject:fileType forKey:fileExtension];
		}
	}
	return [[fileTypesForFiles objectForKey:fileExtension] intValue];
}

- (void) fileFinishedPlaying: (LFile *)file
{
	NSNumber * number = [[file attributes] objectForKey:kPLAY_COUNT];
	int increment = [number intValue] + 1;
	number = [NSNumber numberWithInt:increment];
	[[file attributes] setObject:number forKey:kPLAY_COUNT];
}

- (void) fileStartedPlaying: (LFile *)file
{
    NSString * title = [[file attributes] objectForKey:kTITLE];
	NSMutableString * artist = [[file attributes] objectForKey:kARTIST];
	NSMutableString * album = [[file attributes] objectForKey:kALBUM];
	
	NSMutableString * artistText;
	NSMutableString * albumText;
	if ([artist length])
	{
		artistText = [NSString stringWithFormat:@"%@\n", artist];
	} else {
		artistText = [NSMutableString stringWithString:@""];
	}
	
	if ([album length])
	{
		albumText = [NSString stringWithFormat:@"%@\n", album];
	} else {
		albumText = [NSMutableString stringWithString:@""];
	}
	
	NSImage * image = [[file dictionary] objectForKey:kIMAGE];
	NSData * imageData = [image TIFFRepresentation];
	
    [GrowlApplicationBridge notifyWithTitle:title
                                description:[NSString stringWithFormat:@"%@%@", artistText, albumText]
                           notificationName:@"Basic"
                                   iconData:imageData
                                   priority:0
                                   isSticky:NO
                               clickContext:nil];

}

- (NSMenu *) menuForFiles: (NSArray *) menuFiles
{
	NSArray * addToPlaylists;
	if ([menuFiles count] == 1)
	{
		addToPlaylists = [[menuFiles objectAtIndex:0] notPlaylists];
	} else {
		addToPlaylists = [[LPlaylistController sharedInstance] getPlaylists];
	}
	
	NSMenu * menu = [[[NSMenu alloc] init] autorelease];
	[menu setAutoenablesItems:NO];
	
	NSMenuItem * play = [[[NSMenuItem alloc] init] autorelease];
	[menu addItem:play];
	NSString * title = [(NSDictionary *) [[menuFiles objectAtIndex:0] attributes] objectForKey:kTITLE];
	NSString * playText = [NSString stringWithFormat:@"%@ \"%@\"", kPLAY_TEXT, title];
	[play setTitle:playText];
	[play setTarget:[LPlayerController sharedInstance]];
	[play setRepresentedObject:[menuFiles objectAtIndex:0]];
	[play setAction:@selector(playMenuItem:)];
	
	NSMenuItem * finder = [[[NSMenuItem alloc] init] autorelease];
	[menu addItem:finder];
	[finder setTitle:kSHOW_IN_FINDER_TEXT];
	[finder setTarget: self];
	[finder setAction: @selector(showInFinder:)];
	[finder setRepresentedObject:menuFiles];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem * addToPlaylist = [[[NSMenuItem alloc] init] autorelease];
	[addToPlaylist setTitle: kADD_TO_PLAYLIST_TEXT];
	NSMenu * addToPlaylistMenu = [[[NSMenu alloc] init] autorelease];
	[addToPlaylistMenu setAutoenablesItems:NO];
	[addToPlaylist setSubmenu: addToPlaylistMenu];
	[menu addItem: addToPlaylist];
	
	NSMenuItem * addToNewPlaylist = [[[NSMenuItem alloc] init] autorelease];
	[addToPlaylistMenu addItem:addToNewPlaylist];
	[addToNewPlaylist setTitle:kNEW_PLAYLIST];
	[addToNewPlaylist setTarget:[LPlaylistController sharedInstance]];
	[addToNewPlaylist setAction:@selector(addFilesToNewPlaylistByMenuItem:)];
	[addToNewPlaylist setRepresentedObject:menuFiles];
	
	if ([addToPlaylists count])
	{
		[addToPlaylistMenu addItem:[NSMenuItem separatorItem]];
	}	
	for (LPlaylist * playlist in addToPlaylists)
	{
		if ([playlist smart]) continue;
		NSMenuItem * playlistMenuItem = [[[NSMenuItem alloc] init] autorelease];
		[playlistMenuItem setTitle: [playlist title]];
		[playlistMenuItem setTarget:playlist];
		[playlistMenuItem setAction:@selector(addFilesByMenuItem:)];
		[playlistMenuItem setRepresentedObject:menuFiles];
		
		[addToPlaylistMenu addItem:playlistMenuItem];
	}
		
	for (NSMenuItem * menuItem in [[LExtensionController sharedInstance] menuItemsForFiles:menuFiles])
	{
		[menu addItem:menuItem];
	}
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
	if (! [visiblePlaylist smart])
	{
		NSMenuItem * deleteFromPlaylist = [[[NSMenuItem alloc] init] autorelease];
		[menu addItem:deleteFromPlaylist];
		NSString * deleteFromPlaylistText = [NSString stringWithFormat:@"%@ \"%@\"", kDELETE_FROM_TEXT, [visiblePlaylist title]];
		[deleteFromPlaylist setTitle:deleteFromPlaylistText];
		[deleteFromPlaylist setTarget:visiblePlaylist];
		[deleteFromPlaylist setAction:@selector(removeFilesByMenuItem:)];
		[deleteFromPlaylist setRepresentedObject:menuFiles];
	}
	
	NSMenuItem * deleteFromLibrary = [[[NSMenuItem alloc] init] autorelease];
	[menu addItem:deleteFromLibrary];
	[deleteFromLibrary setTitle:kDELETE_FROM_LIBRARY_TEXT];
	[deleteFromLibrary setTarget:self];
	[deleteFromLibrary setAction:@selector(deleteURLSByMenuItem:)];
	[deleteFromLibrary setRepresentedObject:menuFiles];
	[deleteFromLibrary setKeyEquivalent:[NSString stringWithFormat:@"%c", 0x08]]; // Delete Key
	
	return menu;
}

- (void) showInFinder: (NSMenuItem *) item
{
	for (LFile *file in [item representedObject])
	{
		NSString * path = [[file url] path];
		[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
	}
}
@end
