//
//  LPlayer_QTKit.m
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlayer_QTKit.h"
#import "Lux.h"
#import "LuxAppDelegate.h"

#define controller [LPlayerController sharedInstance]

@implementation LPlayer_QTKit

- (id)init
{
    self = [super init];
    if (self) {
		NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
		[nc addObserver:self selector:@selector(fileEnded) name:QTMovieDidEndNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
	if (player) [player dealloc];
    [super dealloc];
}

- (void) setAndPlayFile: (NSURL*) url withVolume: (double) volume
{
	[self stop];
	
	NSError * error = nil;
	
	player = [[QTMovie alloc] initWithURL:url error:&error];
	
	[self setVolume: volume];
	[self play];
}

- (void) play
{
	[player play];
	isPlaying = YES;

}

- (void) pause
{
	[player stop];
	isPlaying = NO;
}

- (void) stop
{
	[self pause];
}

- (void) setVolume: (double) volume
{
	[player setVolume:volume];
}

- (void) fileEnded
{
	[controller fileDidEnd];
}

- (NSArray *) supportedExtensions
{
	static NSMutableArray * extensions;
	
	if (! extensions)
	{	
		NSArray * possibleExtensions = [QTMovie movieFileTypes:QTIncludeCommonTypes];
		
		extensions = [[NSMutableArray alloc] init];
		
		for (NSString * ext in possibleExtensions)
		{
			if ([ext rangeOfString:@"'"].location == NSNotFound)
			{
				[extensions addObject:ext];
			}
		}
	}
	return extensions;
}

- (int) currentTime
{
	QTTime currentTime = [player currentTime];
	if (currentTime.timeScale == 0) return 0;
	return (int) (currentTime.timeValue * 1000 / currentTime.timeScale);
}

- (int) totalTime
{
	QTTime totalTime = [player duration];
	if (totalTime.timeScale == 0) return 0;
	return (int) (totalTime.timeValue * 1000 / totalTime.timeScale);
}

- (void) setTime: (int) newTime
{
	QTTime time = [player currentTime];
	newTime = (newTime * (int) time.timeScale) / 1000;
	time.timeValue = newTime;
	[player setCurrentTime:time];
}

- (LFileType) fileTypeForExtension: (NSString *) extension
{
	NSArray * extensions;
	
	extensions = [NSArray arrayWithObjects:@"mp3",@"aac",@"wav",@"wma",@"m4a",@"m4p",NULL];
	
	for (NSString * ext in extensions)
	{
		if ([ext isEqualToString:extension])
		{
			return LFileTypeAudio;
		}
	}
	
	extensions = [NSArray arrayWithObjects:@"mov",@"avi",@"wmv",@"mp4",@"flv",@"m4v",NULL];
	
	for (NSString * ext in extensions)
	{
		if ([ext isEqualToString:extension])
		{
			return LFileTypeVideo;
		}
	}
	
	extensions = [NSArray arrayWithObjects:@"m3u",NULL];
	
	for (NSString * ext in extensions)
	{
		if ([ext isEqualToString:extension])
		{
			return LFileTypeStreaming;
		}
	}
	
	return LFileTypeUnknown;
}

- (int) majorVersion
{
	return 1;
}

- (int) minorVersion
{
	return 0;
}

@end
