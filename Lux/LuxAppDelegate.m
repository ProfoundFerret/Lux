//
//  LuxAppDelegate.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LuxAppDelegate.h"
#import "Lux.h"

@implementation LuxAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	// Insert code here to initialize your application
}

- (void)  awakeFromNib
{
	[[Lux sharedInstance] setup];
}

@end
