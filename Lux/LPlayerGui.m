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
	
	[[playPauseMenuItem menu] setAutoenablesItems:NO];
	
	[playPauseMenuItem setTarget:[LPlayerController sharedInstance]];
	[playPauseMenuItem setAction:@selector(playPauseOrStartPlaying)];
	
	[nextMenuItem setTarget:[LPlayerController sharedInstance]];
	[nextMenuItem setAction:@selector(playNextFile)];
	[nextMenuItem setTitle:kNEXT_TEXT];
	
	[previousMenuItem setTarget:[LPlayerController sharedInstance]];
	[previousMenuItem setAction:@selector(playPreviousFile)];
	[previousMenuItem setTitle:kPREVIOUS_TEXT];
	
	[playRecentMenuItem setTitle:kPLAY_RECENT_TEXT];
	
	[repeatMenuItem setTitle:kREPEAT_TEXT];
	[repeatMenuItem setAction:@selector(toggleRepeat)];
	[repeatMenuItem setTarget:[LPlaylistController sharedInstance]];
    [repeatButton setAction:@selector(toggleRepeat)];
	[repeatButton setTarget:[LPlaylistController sharedInstance]];
	
	[shuffleMenuItem setTitle:kSHUFFLE_TEXT];
	[shuffleMenuItem setAction:@selector(toggleShuffle)];
	[shuffleMenuItem setTarget:[LPlaylistController sharedInstance]];
    [shuffleButton setAction:@selector(toggleShuffle)];
	[shuffleButton setTarget:[LPlaylistController sharedInstance]];
	
	[self updateRecentFiles];
	[self updateRepeat];
	[self updateShuffle];
	[self updateNextPrevious];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(play) name:kPLAY_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pause) name:kPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unpause) name:kUNPAUSE_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stop) name:kSTOP_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repeatChanged) name:kREPEAT_CHANGED_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shuffleChanged) name:kSHUFFLE_CHANGED_NOTIFICATION object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activePlaylistChanged) name:kPLAYLIST_ACTIVE_CHANGED_NOTIFICATION object:nil];
	
	[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    
	[self updatePlayPause];
}

- (void) updateRecentFiles
{
	[playRecentMenuItem setSubmenu:[[LPlayerController sharedInstance] recentFilesMenu]];
}

- (void) updateRepeat
{
    BOOL repeat = [[LPlaylistController sharedInstance] repeat];
	if (repeat)
	{
		[repeatButton setState:NSOnState];
		[repeatMenuItem setState:NSOnState];
	} else {
		[repeatButton setState:NSOffState];
		[repeatMenuItem setState:NSOffState];
	}
}

- (void) updateShuffle
{
    BOOL shuffle = [[LPlaylistController sharedInstance] shuffle];
	if (shuffle)
	{
		[shuffleButton setState:NSOnState];
		[shuffleMenuItem setState:NSOnState];
	} else {
		[shuffleButton setState:NSOffState];
		[shuffleMenuItem setState:NSOffState];
	}               
}

- (void) updateNextPrevious
{
	BOOL nextFile = [[LPlayerController sharedInstance] nextFile] != nil;
	[nextMenuItem setEnabled:nextFile];
	[nextButton setEnabled:nextFile];
	
	BOOL previousFile = [[LPlayerController sharedInstance] previousFile] != nil;
	[previousMenuItem setEnabled:previousFile];
	[previousButton setEnabled:previousFile];
}

- (void) repeatChanged
{
    [self updateRepeat];
	[self updateNextPrevious];
}

- (void) shuffleChanged
{
    [self updateShuffle];
}

- (void) activePlaylistChanged
{
	NSLog(@"Active Playlist Changed");
	[self shuffleChanged];
	[self repeatChanged];
}

- (void) play
{
	[self updateTime];
	[self updatePlayPause];
	[self updateRecentFiles];
	[self updateNextPrevious];
}

- (void) pause
{
	[self updateTime];	
	[self updatePlayPause];
}

- (void) unpause
{
	[self updateTime];
	[self updatePlayPause];
}

- (void) stop
{
	[self updateTime];
	[self updatePlayPause];
}

- (void) updatePlayPause
{
	BOOL isPlaying = [[LPlayerController sharedInstance] isPlaying];
    if (isPlaying) {
		[playPauseButton setImage:[NSImage imageNamed:kPAUSE_FILENAME]];
		
		static BOOL hasResizedPlay;
		if (! hasResizedPlay)
		{
			[self resizePlayPauseImage];
			hasResizedPlay = YES;
		}
		[playPauseMenuItem setTitle:kPAUSE_TEXT];
    } else {
		[playPauseButton setImage:[NSImage imageNamed:kPLAY_FILENAME]];
		
		static BOOL hasResizedPause;
		if (! hasResizedPause)
		{
			[self resizePlayPauseImage];
			hasResizedPause = YES;
		}
		[playPauseMenuItem setTitle:kPLAY_TEXT];
    }
}

- (void) resizePlayPauseImage
{
	NSImage * image = [playPauseButton image];
	NSSize newSize = [image size];
	newSize.height = newSize.height * .7;
	newSize.width = newSize.width * .7;
	[image setSize:newSize];
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
