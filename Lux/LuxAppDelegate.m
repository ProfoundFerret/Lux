//
//  LuxAppDelegate.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LuxAppDelegate.h"
#import "Lux.h"
#import "LPlayerController.h"

@implementation LuxAppDelegate

@synthesize window;

- (void) applicationWillFinishLaunching:(NSNotification *)notification
{
}

- (id) init
{
	self = [super init];
	
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	[[Lux sharedInstance] setup];
        
	return self;
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
	[[[Lux sharedInstance] ioController] _save];
}


- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return [[[Lux sharedInstance] playerController] dockMenu];
}

@end
