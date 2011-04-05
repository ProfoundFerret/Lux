//
//  LSingleton.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LSingleton.h"

@implementation LSingleton
static NSMutableDictionary * sharedInstances = nil;
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

+ (id) sharedInstance
{
	LSingleton * sharedInstance;
	@synchronized(self)
	{
		Class myClass = [self class];
		if (! sharedInstances) sharedInstances = [[NSMutableDictionary alloc] init];
		sharedInstance = [sharedInstances objectForKey:myClass];
		if (sharedInstance == nil)
		{
			sharedInstance = [[[myClass alloc] init] autorelease];
			[sharedInstances setObject:sharedInstance forKey:myClass];
		}
	}
	return sharedInstance;
}
@end
