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

@implementation LPlayerController
@synthesize player, recentFiles, isPlaying;
- (id)init
{
    self = [super init];
    if (self) {
		recentFiles = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[player release];
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
		
		[[NSNotificationCenter defaultCenter] postNotificationName:kPLAY_NOTIFICATION object:nil];
		
		[recentFiles removeObject:file];
		if ([recentFiles count] > kMAX_RECENT_FILES) [recentFiles removeObjectAtIndex:0];
		[recentFiles addObject:file];
        
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

- (void) playPauseOrStartPlaying
{
	if (! player)
	{
		LFile * file = [self nextFile];
		
		[self playFile:file];
		isPlaying = YES;
	} else {
		[self playPause];
	}
}

- (void) updateVolume
{
	[player setVolume:[self volumeForFile: [[LFileController sharedInstance] activeFile]]];
    
}

- (void) setTime: (int) newTime
{
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
	NSArray * allFiles = [[[[LPlaylistController sharedInstance] activePlaylist] members] allValues];
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	NSUInteger nextIndex;
	if (! activeFile && ! [activePlaylist shuffle])
	{
		nextIndex = 0;
	} else {
		if ([activePlaylist shuffle])
		{
			nextIndex = arc4random() % [allFiles count];
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
	}
	return [allFiles objectAtIndex:nextIndex];
}

- (LFile *) previousFile
{
	NSArray * allFiles = [[[[LPlaylistController sharedInstance] activePlaylist] members] allValues];
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	NSUInteger nextIndex;
	if (! activeFile && ! [activePlaylist shuffle])
	{
		nextIndex = [allFiles count] - 1;
	} else {
		if ([allFiles indexOfObject:activeFile] == 0)
		{
			if ([activePlaylist repeat])
			{
				nextIndex = [allFiles count] - 1;
			} else {
				return nil;
			}
		} else {
			if ([activePlaylist shuffle])
			{
				nextIndex = arc4random() % [allFiles count];
			} else {
				nextIndex = [allFiles indexOfObject:activeFile] - 1;
			}
		}
	}
	return [allFiles objectAtIndex:nextIndex];
}

- (void) playNextFile
{
	[self playFile:[self nextFile]];
}

- (void) playPreviousFile
{
	[self playFile:[self previousFile]];
}

- (double) volumeForFile: (LFile *) file;
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	double volume = [[defaults objectForKey:kVOLUME] doubleValue];
	
	return volume;
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

- (NSMenu *) dockMenu {
	NSMenu * dockMenu = [[[NSMenu alloc] init] autorelease];
    
    LFile * activeFile = [[LFileController sharedInstance] activeFile];
    
    NSString * artist = [[activeFile attributes] objectForKey:kARTIST];
    NSString * title = [[activeFile attributes] objectForKey:kTITLE];
	
	NSMenuItem *currentSongInfo = [[[NSMenuItem alloc] init] autorelease];
    [currentSongInfo setEnabled:NO];
    NSMenuItem *itispaused = [[[NSMenuItem alloc] init] autorelease];
    
    if (activeFile) {
        if ([artist length])
        {
            [currentSongInfo setTitle:[NSString stringWithFormat:@"%@ - %@", title, artist]];
            [dockMenu addItem:currentSongInfo];
        } else {
            [currentSongInfo setTitle:[NSString stringWithFormat:@"%@", title]];
            [dockMenu addItem:currentSongInfo];
        }
        if (! isPlaying) {
            [itispaused setEnabled:NO];
            [itispaused setTitle:[NSString stringWithFormat:@"%@", kIT_IS_PAUSED]];
            [dockMenu addItem:itispaused];
        }
    } else {
        [currentSongInfo setTitle:[NSString stringWithFormat:@"%@", kNOTHING_PLAYING]];
        [dockMenu addItem:currentSongInfo];

    }
    
    [dockMenu addItem:[NSMenuItem separatorItem]];
    
	NSMenuItem *playPauseOrStart = [[[NSMenuItem alloc] init] autorelease];
	if (isPlaying)
	{
		[playPauseOrStart setTitle:kPAUSE_TEXT];
	} else {
		[playPauseOrStart setTitle:kPLAY_TEXT];
	}
	[playPauseOrStart setTarget:self];
	[playPauseOrStart setAction:@selector(playPauseOrStartPlaying)];
	[dockMenu addItem:playPauseOrStart];
	
	NSMenuItem *nextTrackDockMenu = [[[NSMenuItem alloc] init] autorelease];
	[nextTrackDockMenu setTitle:kNEXT_TEXT];
	[nextTrackDockMenu setTarget:self];
	[nextTrackDockMenu setAction:@selector(playNextFile)];
	[dockMenu addItem:nextTrackDockMenu];
	
	NSMenuItem *previousTrackDockMenu = [[[NSMenuItem alloc] init] autorelease];
	[previousTrackDockMenu setTitle:kPREVIOUS_TEXT];
	[previousTrackDockMenu setTarget:self];
	[previousTrackDockMenu setAction:@selector(playPreviousFile)];
	[dockMenu addItem:previousTrackDockMenu];
	
	if ([recentFiles count] > 1)
	{
		NSMenuItem *playRecent = [[[NSMenuItem alloc] init] autorelease];
		[playRecent setTitle:kPLAY_RECENT_TEXT];
		[dockMenu addItem:playRecent];
		NSMenu * recentFileMenu = [self recentFilesMenu];
		[playRecent setSubmenu:recentFileMenu];
	}
	
	[dockMenu addItem:[NSMenuItem separatorItem]];
	
	[dockMenu addItem:[self repeatMenuItem]];
	
	[dockMenu addItem:[self shuffleMenuItem]];
	 
	
	return dockMenu;
}

- (NSMenu *) recentFilesMenu
{
	NSMenu * recentFileMenu = [[[NSMenu alloc] init] autorelease];
	
	for (NSInteger i = [recentFiles count] - 2; i >= 0; i--) // Subtract 2 because: index starts at 0 AND exclude the current song
	{
		LFile * file = [recentFiles objectAtIndex:i];
		NSMenuItem * fileMenuItem = [[[NSMenuItem alloc] init] autorelease];
		[fileMenuItem setTitle:[[file attributes] objectForKey:kTITLE]];
		[fileMenuItem setTarget:self];
		[fileMenuItem setAction:@selector(playMenuItem:)];
		[fileMenuItem setRepresentedObject:file];
		[recentFileMenu addItem:fileMenuItem];	
	}
	
	return recentFileMenu;
}

- (NSMenuItem *) repeatMenuItem
{
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	
	NSMenuItem * repeat = [[[NSMenuItem alloc] init] autorelease];
	[repeat setTitle:kREPEAT_TEXT];
	[repeat setTarget:activePlaylist];
	[repeat setAction:@selector(toggleRepeat)];
	if ([activePlaylist repeat])
	{
		[repeat setState:NSOnState];
	} else {
		[repeat setState:NSOffState];
	}
	return repeat;
}

- (NSMenuItem *) shuffleMenuItem
{
	LPlaylist * activePlaylist = [[LPlaylistController sharedInstance] activePlaylist];
	
	NSMenuItem * shuffle = [[[NSMenuItem alloc] init] autorelease];
	[shuffle setTitle:kSHUFFLE_TEXT];
	[shuffle setTarget:activePlaylist];
	[shuffle setAction:@selector(toggleShuffle)];
	if ([activePlaylist shuffle])
	{
		[shuffle setState:NSOnState];
	} else {
		[shuffle setState:NSOffState];
	}
	return shuffle;
}

@end
