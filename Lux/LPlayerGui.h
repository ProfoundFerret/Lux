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

}
- (void) changeProgress;
- (void) changeVolume;
- (void) updateTime;

- (void) updatePlayPauseImage;
- (void) resizePlayPauseImage;

- (void) play;
- (void) pause;
- (void) unpause;
- (void) stop;
@end
