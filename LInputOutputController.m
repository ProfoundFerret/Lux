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

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) save
{
    @synchronized(self)
	{
		NSLog(@"Saving");
		
		[NSKeyedArchiver archiveRootObject:[Lux sharedInstance] toFile:kSAVE_FILE];
	}
}


- (void) load
{
	NSLog(@"Loading");
	
	[NSKeyedUnarchiver unarchiveObjectWithFile:kSAVE_FILE];
	
	NSLog(@"Load Finished");
}

- (void) update
{
    @synchronized(self)
	{
		NSLog(@"Updating");
		
		for (LExtension <LInputOutputDelegate> * extension in [self extensions])
		{
			NSArray * extensionURLs = [extension update];
			[[[Lux sharedInstance] fileController] addFilesByURL:extensionURLs];
		}
		
		NSLog(@"Update Finished");
		
		[[Lux sharedInstance] reloadData];
	}}


- (void) addFileByURL: (NSURL *) url
{
	[[[Lux sharedInstance] fileController] addFileByURL: url];
}

- (NSArray *) extensions
{
	return [[LExtensionController sharedInstance] extensionsMatchingDelegate:@protocol(LInputOutputDelegate)];
}

@end
