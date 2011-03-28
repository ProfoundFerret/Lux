//
//  LPlayerGui.m
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlayerGui.h"
#import "LPlayerController.h"
#import "Lux.h"

#define controller [LPlayerController sharedInstance]

#define kPAUSE_FILENAME @"Pause"
#define kPLAY_FILENAME @"Play"

@implementation LPlayerGui

- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) awakeFromNib
{
	[playPauseButton setTarget:controller];
	[playPauseButton setAction:@selector(playPauseOrStartPlaying)];
	
	[previousButton setTarget:controller];
	[previousButton setAction:@selector(playPreviousFile)];
	
	[nextButton setTarget:controller];
	[nextButton setAction:@selector(playNextFile)];
	
	[volumeSlider setTarget:self];
	[volumeSlider setAction:@selector(changeVolume)];
	
	[progressSlider setTarget:self];
	[progressSlider setAction:@selector(changeProgress)];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:kPLAY_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:kUNPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:kPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:kSTOP_NOTIFICATION object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayPauseImage) name:kPLAY_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayPauseImage) name:kPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayPauseImage) name:kUNPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlayPauseImage) name:kSTOP_NOTIFICATION object:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
	[self updatePlayPauseImage];
}

- (void) updatePlayPauseImage
{
	BOOL isPlaying = [[LPlayerController sharedInstance] isPlaying];
    if (isPlaying) {
		[playPauseButton setImage:[NSImage imageNamed:kPAUSE_FILENAME]];
    } else {
		[playPauseButton setImage:[NSImage imageNamed:kPLAY_FILENAME]];
    }
//	static BOOL hasResized = NO;
//	if (! hasResized)
//	{
//		NSImage * image = [playPauseButton image];
//		NSSize newSize = [image size];
//		newSize.height = newSize.height * .7;
//		newSize.width = newSize.width * .7;
//		[image setSize:newSize];
//		
//		hasResized = YES;
//	}
}

- (void) updateTime;
{
	[progressSlider setMaxValue:[controller totalTime]];
	[progressSlider setIntValue:[controller curTime]];
}

- (void) changeVolume
{
	[controller updateVolume];
}

- (void) changeProgress
{
	[controller setTime:[progressSlider intValue]];
}

@end
