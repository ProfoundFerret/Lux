//
//  LControllerObject.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LControllerObject.h"
#import "Lux.h"

@implementation LControllerObject

- (id)init
{
    self = [super init];
    if (self) {
		guis = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	Class myClass = [self class];
	self = [myClass sharedInstance];
	return [self retain];
}

- (void) reloadData
{
	for (LGuiObject * gui in guis)
	{
		[gui reloadData];
	}
}

- (void) addGui: (LGuiObject *) gui
{
	[guis addObject:gui];
}
@end
