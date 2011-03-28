//
//  LPlayerController.h
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LExtension.h"
#import "LFile.h"
#import "LPlayerGui.h"

#define kUNPAUSE_NOTIFICATION @"unpause_notification"
#define kPAUSE_NOTIFICATION @"unpause_notification"
#define kPLAY_NOTIFICATION @"play_notification"
#define kSTOP_NOTIFICATION @"stop_notification"
#define kNOTHING_PLAYING @"Nothing playing"
#define kIT_IS_PAUSED @"(Paused)"


#define kRECENT_FILES @"recentFiles"

#define kPLAY_TEXT @"Play"
#define kPAUSE_TEXT @"Pause"
#define kNEXT_TEXT @"Next"
#define kPREVIOUS_TEXT @"Previous"
#define kPLAY_RECENT_TEXT @"Play Recent"

#define kMAX_RECENT_FILES 10

@interface LPlayerController : LControllerObject {
	LExtension <LPlayerDelegate> * player;
	BOOL isPlaying;
	NSMutableArray * recentFiles;
    
}
- (void) playFile: (LFile *) file;
- (void) playPauseOrStartPlaying;
- (void) stopPlayer;
- (void) fileDidEnd;
- (void) updateVolume;
- (void) setTime: (int) newTime;
- (LExtension *) playerForFile: (LFile *) file;
- (LFile *) nextFile;
- (LFile *) previousFile;
- (void) playPause;
- (void) playNextFile;
- (void) playPreviousFile;
- (double) volumeForFile: (LFile *) file;
- (int) curTime;
- (int) totalTime;
- (void) playMenuItem: (NSMenuItem *) menuItem;
- (NSMenu *) dockMenu;

- (NSArray *) extensions;

@property (readonly) NSMutableArray * recentFiles;
@property (readonly) LExtension <LPlayerDelegate> * player;
@property (readonly) BOOL isPlaying;
@end
