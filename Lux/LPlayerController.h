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

#define kUNPAUSE_NOTIFICATION @"unpause_notification"
#define kPAUSE_NOTIFICATION @"unpause_notification"
#define kPLAY_NOTIFICATION @"play_notification"
#define kSTOP_NOTIFICATION @"stop_notification"

@interface LPlayerController : LControllerObject {
	LExtension <LPlayerDelegate> * player;
	BOOL isPlaying;
    
    NSMenu *dynamicMenu;
    NSMenuItem *dynamicItem;
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
- (void) setupTheDockMenu;
- (NSMenu *) returnTheDockMenu;

- (NSArray *) extensions;

- (void) _playFile: (LFile *) file;


@property (readonly) LExtension <LPlayerDelegate> * player;
@end
