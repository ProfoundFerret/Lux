//
//  LInputOutputController.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LInputOutputController.h"
#import "Lux.h"
#import "LExtensionController.h"

@implementation LInputOutputController
@synthesize needsSaved;
- (id)init
{
    self = [super init];
    if (self) {
		[NSTimer scheduledTimerWithTimeInterval:kAUTOSAVE_INTERVAL target:self selector:@selector(save) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) save
{
	[NSThread detachNewThreadSelector:@selector(_save) toTarget:self withObject:nil];
}

- (void) _save
{
	if (! needsSaved || ! loaded) return;
	needsSaved = NO;
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init]; 
	@synchronized(self)
	{
		NSLog(@"Saving");
		[NSKeyedArchiver archiveRootObject:[Lux sharedInstance] toFile:kSAVE_FILE];
		NSLog(@"Save Finished");
	}
	[pool drain];
}

- (void) load
{
	NSLog(@"Loading");
	
	[NSKeyedUnarchiver unarchiveObjectWithFile:kSAVE_FILE];
	loaded = YES;
	
	NSLog(@"Load Finished");
}

- (void) update
{
	[NSThread detachNewThreadSelector:@selector(_update) toTarget:self withObject:nil];
}

- (void) _update
{
	@synchronized(self)
	{
		NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
		NSLog(@"Updating");
		
		for (LExtension <LInputOutputDelegate> * extension in [self extensions])
		{
			NSArray * extensionURLs = [extension update];
			[[[Lux sharedInstance] fileController] addFilesByURL:extensionURLs];
		}
		
		needsSaved = YES;
		NSLog(@"Update Finished");
		
		[[Lux sharedInstance] reloadData];
		[pool drain];
	}
}

- (void) addFileByURL: (NSURL *) url
{
	[[[Lux sharedInstance] fileController] addFileByURL: url];
}

- (NSArray *) extensions
{
	return [[LExtensionController sharedInstance] extensionsMatchingDelegate:@protocol(LInputOutputDelegate)];
}

@end