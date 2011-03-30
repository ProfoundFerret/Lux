//
//  LPlayerGui.h
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGuiObject.h"

@interface LPlayerGui : LGuiObject {
	IBOutlet NSButton * playPauseButton;
	IBOutlet NSButton * nextButton;
	IBOutlet NSButton * previousButton;
	IBOutlet NSSlider * volumeSlider;
	IBOutlet NSSlider * progressSlider;
	
	IBOutlet NSMenuItem * playPauseMenuItem;
	IBOutlet NSMenuItem * nextMenuItem;
	IBOutlet NSMenuItem * previousMenuItem;
	IBOutlet NSMenuItem * playRecentMenuItem;
	IBOutlet NSMenuItem * repeatMenuItem;
	IBOutlet NSMenuItem * shuffleMenuItem;
	
    IBOutlet NSButton   * repeatButton;
	IBOutlet NSButton   * shuffleButton;

}
- (void) changeProgress;
- (void) changeVolume;
- (void) updateTime;

- (void) updatePlayPause;
- (void) resizePlayPauseImage;

- (void) play;
- (void) pause;
- (void) unpause;
- (void) stop;
- (void) activePlaylistChanged;
- (void) repeatChanged;
- (void) shuffleChanged;
- (void) updateNextPrevious;

- (void) updateRecentFiles;
- (void) updateRepeat;
- (void) updateShuffle;
@end
