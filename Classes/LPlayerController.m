//
//  LPlayerController.m
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlayerController.h"
#import "LExtensionController.h"
#import "LFileController.h"
#import "LPlaylistController.h"
#import "Lux.h"
#import "LuxAppDelegate.h"
#import "LDefinitions.h"

@implementation LPlayerController
@synthesize player, recentFiles, isPlaying;
- (id)init
{
    self = [super init];
    if (self) {
		recentFiles = [[NSMutableArray alloc] init];
		video = [[LPlayerVideo alloc] init];
		
		[self setupRemoteControl];
    }
    
    return self;
}

- (void)dealloc
{
	[player release];
	[remoteControl release];
    [super dealloc];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:recentFiles forKey:kRECENT_FILES];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	recentFiles = [[aDecoder decodeObjectForKey:kRECENT_FILES] retain];
	
	[self setupRemoteControl];
	return [self retain];
}

- (NSArray *) extensions
{
	return [[LExtensionController sharedInstance] extensionsMatchingDelegate:@protocol(LPlayerDelegate)];
}

- (void) playFile: (LFile*) file
{
	@synchronized(self)
	{
        
		LPlaylist * visiblePlaylist = [[LPlaylistController sharedInstance] visiblePlaylist];
		[[LPlaylistController sharedInstance] setActivePlaylist:visiblePlaylist];
		
		if (! file) return;
		LExtension * newPlayer = [self playerForFile: file];
		
		if (! newPlayer)
		{
			isPlaying = NO;
			return; // Shouldn't pop up but you never know.
		}
		[self stopPlayer];
		
		double volume = [self volumeForFile:file];
		
		player = newPlayer;
		[[LFileController sharedInstance] setActiveFile:file];
		[player setAndPlayFile:[file url] withVolume:volume];
		[[LFileController sharedInstance] fileStartedPlaying:file];
		isPlaying = YES;
		
		if ([file fileType] == LFileTypeVideo)
		{
			NSView * view = [[video window] contentView];
			[player playVideoInView:view];
		} else {
			[self setFullscreen:NO];
			[[video window] close];
		}
		
		[recentFiles removeObject:file];
		if ([recentFiles count] > kMAX_RECENT_FILES) [recentFiles removeObjectAtIndex:0];
		[recentFiles addObject:file];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kPLAY_NOTIFICATION object:nil];
	}
}
- (LExtension <LPlayerDelegate> *) playerForFile: (LFile *) file
{
	NSString * fileExtension = [file extension];
	for (LExtension <LPlayerDelegate> * ext in [self extensions])
	{
		if ([[ext supportedExtensions] containsObject:fileExtension])
		{
			return ext;
		}
	}
	return nil;
}

- (void) stopPlayer
{
	if (! player) return;
	[player stop];
	isPlaying = NO;
}

- (void) playPause
{
	if (! player)
	{
		LFile * file = [[LFileController sharedInstance] activeFile];
		if (! file) file = [self nextFile];
		
		[self playFile:file];
		isPlaying = YES;
	} else {
		if (isPlaying)
		{
			[player pause];
			isPlaying = ! isPlaying;
			[[NSNotificationCenter defaultCenter] postNotificationName:kPAUSE_NOTIFICATION object:nil];
		} else 
		{
			[player play];
			isPlaying = ! isPlaying;
			[[NSNotificationCenter defaultCenter] postNotificationName:kUNPAUSE_NOTIFICATION object:nil];
		}
	}
}

- (void) updateVolume
{
	[player setVolume:[self volume]];
    
}

- (void) setTime: (int) newTime
{
	int totalTime = [player totalTime];
	newTime = (newTime > totalTime) ? totalTime : newTime;
	[player setTime: newTime];
}

- (void) fileDidEnd
{
	[self stopPlayer];
	[[NSNotificationCenter defaultCenter] postNotificationName:kSTOP_NOTIFICATION object:nil];
	
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	[[LFileController sharedInstance] fileFinishedPlaying:activeFile]; 
	
	[self playNextFile];
}

- (LFile *) nextFile
{
	NSArray * allFiles = [[[LPlaylistController sharedInstance] activePlaylist] members];
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	NSUInteger nextIndex;
	if ([activePlaylist shuffle] && [allFiles count])
	{
		nextIndex = arc4random() % [allFiles count];
	}
	else if (! activeFile)
	{
		nextIndex = 0;
	} else {
		nextIndex = [allFiles indexOfObject:activeFile] + 1;
	}

	if ([allFiles count] <= nextIndex)
	{
		if ([activePlaylist repeat])
		{
			nextIndex = 0;
		} else {
			return nil;
		}
	}
	return [allFiles objectAtIndex:nextIndex];
}

- (LFile *) previousFile
{
	NSArray * allFiles = [[[LPlaylistController sharedInstance] activePlaylist] members];
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	NSUInteger nextIndex;

	if ([activePlaylist shuffle] && [allFiles count])
	{
		nextIndex = arc4random() % [allFiles count];
	}
	else if (! activeFile)
	{
		nextIndex = 0;
	} else {
		nextIndex = [allFiles indexOfObject:activeFile] - 1;
	}
	
	if ([allFiles count] <= nextIndex)
	{
		if ([activePlaylist repeat])
		{
			nextIndex = [allFiles count] - 1;
		} else {
			return nil;
		}
	}
	return [allFiles objectAtIndex:nextIndex];
}

- (void) playNextFile
{
	BOOL playing = isPlaying;
	[self playFile:[self nextFile]];
	if (! playing)
	{
		[self playPause];
	}
}

- (void) playPreviousFile
{
	BOOL playing = isPlaying;
	[self playFile:[self previousFile]];
	if (! playing)
	{
		[self playPause];
	}
}

- (double) volumeForFile: (LFile *) file;
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	double volume = [[defaults objectForKey:kVOLUME] doubleValue];
	
	return volume;
}

- (void) setVolume: (double) volume
{	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	volume = (volume > 1) ? 1 : volume;
	volume = (volume < 0) ? 0 : volume;
	
	[defaults setObject:[NSNumber numberWithDouble:volume] forKey:kVOLUME];
	
	[self updateVolume];
}

- (double) volume
{
	return [self volumeForFile: [[LFileController sharedInstance] activeFile]];
}

- (void) incrementTime
{	
	int time = [self curTime];
	time += kTIME_INCREMENT;
	[self setTime:time];
}

- (void) decrementTime
{
	int time = [self curTime];
	time -= kTIME_INCREMENT;
	[self setTime:time];
}

- (void) incrementVolume
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	double volume = [[defaults objectForKey:kVOLUME] doubleValue];
	
	[self setVolume: volume + kVOLUME_INCREMENT];
}

- (void) decrementVolume
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	double volume = [[defaults objectForKey:kVOLUME] doubleValue];
	
	[self setVolume: volume - kVOLUME_INCREMENT];
}

- (void) startTimeScrubbing // TODO: Doesn't work yet
{
	[self stopTimeScrubbing];
	timeScrubbingTimer = [[NSTimer alloc] initWithFireDate:[NSDate date] interval:kTIME_SCRUB_FREQUENCY target:self selector:@selector(incrementTime) userInfo:nil repeats:YES];
}

- (void) stopTimeScrubbing
{
	if (! timeScrubbingTimer) return;
	[timeScrubbingTimer invalidate];
	[timeScrubbingTimer autorelease];
}

- (int) curTime
{
	return [player currentTime];
}

- (int) totalTime
{
	return [player totalTime];
}

- (void) playMenuItem: (NSMenuItem *) menuItem
{
	[self playFile:[menuItem representedObject]];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    return [menuItem isEnabled];
}

- (NSMenuItem *) playpauseMenuItem
{
	NSMenuItem *playPauseOrStart = [[[NSMenuItem alloc] init] autorelease];
	if (isPlaying)
	{
		[playPauseOrStart setTitle:kPAUSE_TEXT];
	} else {
		[playPauseOrStart setTitle:kPLAY_TEXT];
	}
	[playPauseOrStart setTarget:self];
	[playPauseOrStart setAction:@selector(playPause)];
	
	return playPauseOrStart;
}

- (NSMenuItem *) nextTrackMenuItem
{
	NSMenuItem *nextTrackMenuItem = [[[NSMenuItem alloc] init] autorelease];
	[nextTrackMenuItem setTitle:kNEXT_TEXT];
	[nextTrackMenuItem setTarget:self];
	[nextTrackMenuItem setAction:@selector(playNextFile)];
	
	return nextTrackMenuItem;
}

- (NSMenuItem *) previousTrackMenuItem
{
	NSMenuItem *previousTrackMenuItem = [[[NSMenuItem alloc] init] autorelease];
	[previousTrackMenuItem setTitle:kPREVIOUS_TEXT];
	[previousTrackMenuItem setTarget:self];
	[previousTrackMenuItem setAction:@selector(playPreviousFile)];
	
	return previousTrackMenuItem;
}

- (NSMenuItem *) currentTrackMenuItem
{
    LFile * activeFile = [[LFileController sharedInstance] activeFile];
    NSString * artist = [[activeFile attributes] objectForKey:kARTIST];
    NSString * title = [[activeFile attributes] objectForKey:kTITLE];
	
	NSMenuItem *currentSongMenuItem = [[[NSMenuItem alloc] init] autorelease];
    [currentSongMenuItem setEnabled:NO];
    
    if (activeFile) {
        if ([artist length])
        {
            [currentSongMenuItem setTitle:[NSString stringWithFormat:@"%@ %@ %@", title, kEM_DASH, artist]];
        } else {
            [currentSongMenuItem setTitle:title];
        }
        if (! isPlaying) {
            [currentSongMenuItem setTitle:kPAUSED_TEXT];
        }
    } else {
        [currentSongMenuItem setTitle:kNOTHING_PLAYING_TEXT];
    }
	return currentSongMenuItem;
}

- (NSMenuItem *) recentFilesMenuItem
{
	NSMenuItem *playRecent = [[[NSMenuItem alloc] init] autorelease];
	[playRecent setTitle:kPLAY_RECENT_TEXT];
	NSMenu * recentFileMenu = [[[NSMenu alloc] init] autorelease];
	
	for (NSInteger i = [recentFiles count] - 2; i >= 0; i--)
	{
		LFile * file = [recentFiles objectAtIndex:i];
		NSMenuItem * fileMenuItem = [[[NSMenuItem alloc] init] autorelease];
		[fileMenuItem setTitle:[[file attributes] objectForKey:kTITLE]];
		[fileMenuItem setTarget:self];
		[fileMenuItem setAction:@selector(playMenuItem:)];
		[fileMenuItem setRepresentedObject:file];
		[recentFileMenu addItem:fileMenuItem];	
	}
	
	[playRecent setSubmenu:recentFileMenu];
	
	return playRecent;
}

- (NSMenu *) videoMenu
{
	NSMenu * menu = [[[NSMenu alloc] init] autorelease];
	
	[menu addItem:[self playpauseMenuItem]];
	[menu addItem:[self fullscreenMenuItem]];
	
	return menu;
}

- (NSMenu *) dockMenu {
	NSMenu * menu = [[[NSMenu alloc] init] autorelease];
    
    [menu addItem:[NSMenuItem separatorItem]];
    
	[menu addItem:[self playpauseMenuItem]];
	
	[menu addItem:[self nextTrackMenuItem]];
	
	[menu addItem:[self previousTrackMenuItem]];
	
	if ([recentFiles count] > 1)
	{
		[menu addItem:[self recentFilesMenuItem]];
	}
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	[menu addItem:[self repeatMenuItem]];
	
	[menu addItem:[self shuffleMenuItem]];
	
	[menu addItem:[self fullscreenMenuItem]]; 
	
	return menu;
}

- (NSMenuItem *) repeatMenuItem
{	
	NSMenuItem * repeat = [[[NSMenuItem alloc] init] autorelease];
	[repeat setTitle:kREPEAT_TEXT];
	[repeat setTarget:[LPlaylistController sharedInstance]];
	[repeat setAction:@selector(toggleRepeat)];
	if ([[LPlaylistController sharedInstance] repeat])
	{
		[repeat setState:NSOnState];
	} else {
		[repeat setState:NSOffState];
	}
	return repeat;
}

- (NSMenuItem *) fullscreenMenuItem
{
	NSMenuItem * fullscreenMenuItem = [[[NSMenuItem alloc] init] autorelease];
	[fullscreenMenuItem setTitle:kFULLSCREEN_TEXT];
	[fullscreenMenuItem setTarget:self];
	[fullscreenMenuItem setAction:@selector(toggleFullscreen)];
	if (fullscreen)
	{
		[fullscreenMenuItem setState:NSOnState];
	} else {
		[fullscreenMenuItem setState:NSOffState];
	}
	
	return fullscreenMenuItem;
}

- (NSMenuItem *) shuffleMenuItem
{	
	NSMenuItem * shuffle = [[[NSMenuItem alloc] init] autorelease];
	[shuffle setTitle:kSHUFFLE_TEXT];
	[shuffle setTarget:[LPlaylistController sharedInstance]];
	[shuffle setAction:@selector(toggleShuffle)];
	if ([[LPlaylistController sharedInstance] shuffle])
	{
		[shuffle setState:NSOnState];
	} else {
		[shuffle setState:NSOffState];
	}
	return shuffle;
}

- (void) setupRemoteControl
{	
	if (! remoteControl)
	{
		remoteControl = [[AppleRemote alloc] initWithDelegate:self];
		
		remoteBehavior = [MultiClickRemoteBehavior new];
		[remoteBehavior setDelegate:self];
		[remoteControl setDelegate:remoteBehavior];
		
		[remoteControl retain];
		
		[remoteControl startListening:self];
		[remoteControl setOpenInExclusiveMode:YES];
	}
}

- (void) remoteButton: (RemoteControlEventIdentifier)buttonIdentifier pressedDown: (BOOL) pressedDown clickCount: (unsigned int)clickCount
{
	switch(buttonIdentifier) {
		case kRemoteButtonPlus:
			// Volume Up	
			if (! pressedDown) [self incrementVolume];	
			break;
		case kRemoteButtonMinus:
			// Volume Down
			if (! pressedDown) [self decrementVolume];
			break;			
		case kRemoteButtonMenu:
			// Menu
			break;			
		case kRemoteButtonPlay:
			// Play
			if (! pressedDown) [self playPause];
			[self startTimeScrubbing];
			break;			
		case kRemoteButtonRight:	
			// Right
			if (! pressedDown) [self playNextFile];
			break;			
		case kRemoteButtonLeft:
			// Left
			if (! pressedDown) [self playPreviousFile];
			break;			
		case kRemoteButtonRight_Hold:
			// Right Hold
			[self startTimeScrubbing];
			break;	
		case kRemoteButtonLeft_Hold:
			// Left Hold
			//[self stopTimeScrubbing];
			break;			
		case kRemoteButtonPlus_Hold:
			// Volume Up Hold
			break;				
		case kRemoteButtonMinus_Hold:			
			// Volume Down Hold	
			break;
		case kRemoteButtonMenu_Hold:
			break;
		case kRemoteControl_Switched:
			break;
		default:
			break;
	}
}

- (void) setFullscreen: (BOOL) newFullScreen
{
	if (fullscreen == newFullScreen) return;
	fullscreen = newFullScreen;
	
	if (fullscreen)
	{
		[[[video window] contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionary]];
	} else {
		[[[video window] contentView] exitFullScreenModeWithOptions:[NSDictionary dictionary]];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:kFULLSCREEN_CHANGED object:nil];
}

- (void) toggleFullscreen
{
	[self setFullscreen: ! fullscreen];
}
@end
