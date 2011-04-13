//
//  LLyricsFetcher.h
//  Lux
//
//  Created by Adrien Bertrand on 07/04/11.
//  Copyright 2011 Adrien Bertrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LExtension.h"
#import "Lux.h"

#define kLYRICS_FOUND @"lyricsfound_notification"

@interface LLyricsFetcher : LExtension <NSXMLParserDelegate> {
	NSString * lyrics;
    bool forced;
}    

- (void) fetchLyricsForSong;
- (void) fetchLyricsForFiles: (NSArray *)files;
- (void) fetchLyricsForFilesFromMenuItem: (NSMenuItem *) menuItem;

@end
