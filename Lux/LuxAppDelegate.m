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

- (BOOL)applicationShouldHandleReopen:(NSApplication *)sender
                    hasVisibleWindows:(BOOL)flag
{
    [window makeKeyAndOrderFront:sender];
    return YES;
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
    
}

- (void) awakeFromNib
{

}

- (id) init
{
	self = [super init];
	
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	
	[[Lux sharedInstance] setup];
    
    [self setupGrowl]; 
              
	return self;
}


- (void) setupGrowl
{
    NSBundle *myBundle = [NSBundle bundleForClass:[LuxAppDelegate class]];
	NSString *growlPath = [[myBundle privateFrameworksPath] stringByAppendingPathComponent:@"Growl.framework"];
	NSBundle *growlBundle = [NSBundle bundleWithPath:growlPath];
    
	if (growlBundle && [growlBundle load]) {
		// Register ourselves as a Growl delegate
		[GrowlApplicationBridge setGrowlDelegate:self];
        
        NSLog(@"Growl Registered");
	}
	else {
		NSLog(@"ERROR: Could not load Growl.framework");
	}
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
