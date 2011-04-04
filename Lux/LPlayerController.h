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

#import "AppleRemote.h"
#import "MultiClickRemoteBehavior.h"
#import "HIDRemoteControlDevice.h"

@interface LPlayerController : LControllerObject {
	LExtension <LPlayerDelegate> * player;
	BOOL isPlaying;
	NSMutableArray * recentFiles;
	
	AppleRemote * remoteControl;
	MultiClickRemoteBehavior * remoteBehavior;
	
	NSTimer * timeScrubbingTimer;
}
- (void) playFile: (LFile *) file;
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
- (double) volume;
- (int) curTime;
- (int) totalTime;
- (void) playMenuItem: (NSMenuItem *) menuItem;
- (NSMenu *) dockMenu;

- (NSMenu *) recentFilesMenu;
- (NSMenuItem *) repeatMenuItem;
- (NSMenuItem *) shuffleMenuItem;

- (void) setVolume: (double) volume;

- (void) incrementVolume;
- (void) decrementVolume;

- (void) incrementTime;
- (void) decrementTime;

- (void) startTimeScrubbing;
- (void) stopTimeScrubbing;

- (NSArray *) extensions;

- (void) setupRemoteControl;
- (void) remoteButton: (RemoteControlEventIdentifier)buttonIdentifier pressedDown: (BOOL) pressedDown clickCount: (unsigned int)clickCount;

@property (readonly) NSMutableArray * recentFiles;
@property (readonly) LExtension <LPlayerDelegate> * player;
@property (readonly) BOOL isPlaying;
@end
