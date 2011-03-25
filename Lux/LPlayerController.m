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

@implementation LPlayerController
@synthesize player;
- (id)init
{
    self = [super init];
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
	[player release];
    [super dealloc];
}

- (NSArray *) extensions
{
	return [[LExtensionController sharedInstance] extensionsMatchingDelegate:@protocol(LPlayerDelegate)];
}

- (void) playFile: (LFile*) file
{
	[NSThread detachNewThreadSelector:@selector(_playFile:) toTarget:self withObject:file];
}

- (void) _playFile: (LFile *) file
{
	@synchronized(self)
	{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		
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
		
		[pool drain];
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
		[[NSNotificationCenter defaultCenter] postNotificationName:kPAUSE_NOTIFICATION object:nil];
		[player pause];
	} else 
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:kUNPAUSE_NOTIFICATION object:nil];
		[player play];
	}
	isPlaying = ! isPlaying;
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
	NSUInteger nextIndex;
	if (! activeFile)
	{
		nextIndex = 0;
	} else {
		nextIndex = [allFiles indexOfObject:activeFile] + 1;
		if ([allFiles count] <= nextIndex)
		{
			return nil;
			// nextIndex = 0; // TODO: Only if repeat is on
		}
	}
	return [allFiles objectAtIndex:nextIndex];
}

- (LFile *) previousFile
{
	NSArray * allFiles = [[[[LPlaylistController sharedInstance] activePlaylist] members] allValues];
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	NSUInteger previousIndex;
	if (! activeFile)
	{
		previousIndex = 0;
	} else {
		if ([allFiles indexOfObject:activeFile] == 0)
		{
			return nil;
			// TODO: Play the very last song if repeat is on
		} else {
			previousIndex = [allFiles indexOfObject:activeFile] - 1;
		}
	}
	return [allFiles objectAtIndex:previousIndex];
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
@end
