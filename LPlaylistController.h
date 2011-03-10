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
#define kACTIVEPLAYLIST @"activePlaylist"

@interface LPlaylistController : LControllerObject {
    NSMutableDictionary * playlists;
	LPlaylist * activePlaylist;
}

- (void) setupLibraryPlaylists;

- (void) addPlaylist: (LPlaylist *) playlist;
- (void) addPlaylist: (LPlaylist *) playlist toGroupNamed:(NSString *) name;

- (NSMutableArray *) getPlaylists;
- (NSMutableArray *) getPlaylistsFromGroup: (NSString *) name;
- (NSMutableArray *) allPlaylists;

- (void) prepPlaylistsForUpdate;

- (void) searchChangedTo: (NSString *) search;

@property (readwrite, assign) NSMutableDictionary * playlists;
@property (readonly, retain) LPlaylist * activePlaylist;
@end
