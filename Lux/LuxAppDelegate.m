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

- (void)  awakeFromNib
{
	if(getenv("NSZombieEnabled") || getenv("NSAutoreleaseFreedObjectCheckEnabled")) {
        NSLog(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
	}
	[[Lux sharedInstance] setup];
}

@end
