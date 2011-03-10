//
//  _Test.m
//  Lux
//
//  Created by Kyle Carson on 3/9/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "_Test.h"
#import "LPlaylist.h"

@implementation _Test

- (id)init
{
    self = [super init];
    if (self) {
		[self go];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) go
{
	NSLog(@"Testing");
	
	
	
	NSLog(@"Ending Test");
}

@end
