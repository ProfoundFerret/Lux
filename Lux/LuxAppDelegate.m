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

- (NSDictionary *) registrationDictionaryForGrowl
{
    NSArray *notifications;
    notifications = [NSArray arrayWithObjects: @"Basic", nil];    
    NSDictionary *dict;
    
    dict = [NSDictionary dictionaryWithObjectsAndKeys:
            notifications, GROWL_NOTIFICATIONS_ALL,
            notifications, GROWL_NOTIFICATIONS_DEFAULT, nil];
    
    return (dict);
    
} // registrationDictionaryForGrowl

- (id) init
{
	self = [super init];
	
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	[[Lux sharedInstance] setup];
    
    NSBundle *myBundle = [NSBundle bundleForClass:[LuxAppDelegate class]];
	NSString *growlPath = [[myBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
    
	if (growlBundle && [growlBundle load]) {
		// Register ourselves as a Growl delegate
		[GrowlApplicationBridge setGrowlDelegate:self];
        
        [GrowlApplicationBridge notifyWithTitle:@"Alert"
                                    description:@"Hello!"
                               notificationName:@"Basic"
                                       iconData:nil
                                       priority:2
                                       isSticky:NO
                                   clickContext:[NSDate date]];
        
        NSLog(@"i am here");
	}
	else {
		NSLog(@"ERROR: Could not load Growl.framework");
	}
        
	return self;
}

- (void) applicationWillTerminate:(NSNotification *)notification
{
	[[[Lux sharedInstance] ioController] save];
}


- (NSMenu *)applicationDockMenu:(NSApplication *)sender
{
    return [[[Lux sharedInstance] playerController] dockMenu];
}

@end
