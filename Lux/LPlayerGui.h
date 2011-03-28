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

- (void) repeatChanged;
- (void) updateNextPrevious;

- (void) playPauseMenuItem: (NSMenuItem *) menuItem;
- (void) nextMenuItem: (NSMenuItem *) menuItem;
- (void) previousMenuItem: (NSMenuItem *) menuItem;
- (void) repeatMenuItem: (NSMenuItem *) menuItem;
- (void) shuffleMenuItem: (NSMenuItem *) menuItem;

- (void) updateRecentFiles;
- (void) updateRepeat;
- (void) updateShuffle;
@end
