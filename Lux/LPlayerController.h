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

@interface LPlayerController : LControllerObject {
	LExtension <LPlayerDelegate> * player;
	BOOL isPlaying;
}
- (void) playFile: (LFile *) file;
- (void) playPauseOrStartPlaying;
- (void) stopPlayer;
- (void) fileDidEnd;
- (void) setVolume: (double) newVolume;
- (void) setTime: (int) newTime;
- (LExtension *) playerForFile: (LFile *) file;
- (LFile *) nextFile;
- (LFile *) previousFile;
- (void) playPause;
- (void) playNextFile;
- (void) playPreviousFile;
- (double) volumeForFile: (LFile *) file;

- (NSArray *) extensions;

- (void) _playFile: (LFile *) file;

@property (readonly) LExtension <LPlayerDelegate> * player;
@end
