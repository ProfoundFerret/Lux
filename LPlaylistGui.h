//
//  LPlaylistGui.h
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPlaylist.h"
#import "LGuiObject.h"
#import "LOutlineView.h"

@interface LPlaylistGui : LGuiObject <NSOutlineViewDelegate, NSOutlineViewDataSource> {
    IBOutlet LOutlineView * playlistList;
	IBOutlet NSSearchField * searchField;
	IBOutlet NSButton * addPlaylistButton;
	IBOutlet NSMenuItem * searchMenuItem;
	IBOutlet NSMenuItem * newPlaylistMenuItem;
	
	LPlaylist * visiblePlaylist;
}
- (void) searchChanged;
- (LPlaylist *) visiblePlaylist;
- (void) addPlaylist;

- (void) selectSearchField;

- (void) renamePlaylist: (LPlaylist *) playlist;
- (void) renamePlaylistByNotification: (NSNotification *) notification;
@end
