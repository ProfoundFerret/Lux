//
//  LPlaylistController.h
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LPlaylist.h"

#define kPLAYLISTS @"Playlists"
#define kLIBRARY @"Library"
#define kACTIVE_PLAYLIST @"activePlaylist"
#define kVISIBLE_PLAYLIST @"visiblePlaylist"

@interface LPlaylistController : LControllerObject {
    NSMutableDictionary * playlists;
	LPlaylist * activePlaylist;
	LPlaylist * visiblePlaylist;
}

- (void) setupLibraryPlaylists;

- (void) addPlaylist: (LPlaylist *) playlist;
- (void) addPlaylist: (LPlaylist *) playlist toGroupNamed:(NSString *) name;
- (void) addFilesToNewPlaylist: (NSArray *) files;

- (void) removePlaylist: (LPlaylist *) playlist;
- (void) removePlaylist: (LPlaylist *) playlist fromGroupNamed: (NSString *) name;

- (void) duplicatePlaylist: (LPlaylist *) playlist;
- (void) convertToRegularPlaylist: (LPlaylist *) playlist;

- (NSMutableArray *) getPlaylists;
- (NSMutableArray *) getPlaylistsFromGroup: (NSString *) name;
- (NSMutableArray *) allPlaylists;

- (NSMenu *) menuForPlaylist: (LPlaylist *) playlist;

- (void) prepPlaylistsForUpdate;

- (void) searchChangedTo: (NSString *) search;

- (void) addFilesToNewPlaylistByMenuItem: (NSMenuItem *) menuItem;
- (void) dupliatePlaylistByMenuItem: (NSMenuItem *) menuItem;
- (void) deletePlaylistByMenuItem: (NSMenuItem *) menuItem;
- (void) convertToRegularPlaylistByMenuItem: (NSMenuItem *) menuItem;

- (BOOL) shuffle;
- (BOOL) repeat;

- (void) setShuffle: (BOOL) shuffle;
- (void) setRepeat: (BOOL) repeat;

- (void) toggleShuffle;
- (void) toggleRepeat;

- (void) setActivePlaylist: (LPlaylist *) newActivePlaylist;
- (void) setVisiblePlaylist: (LPlaylist *) newVisiblePlaylist;

@property (readwrite, assign) NSMutableDictionary * playlists;
@property (readonly, nonatomic) LPlaylist * activePlaylist;
@property (readonly, nonatomic) LPlaylist * visiblePlaylist;
@end
