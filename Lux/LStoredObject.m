//
//  LStoredObject.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LStoredObject.h"


@implementation LStoredObject

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

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	return self;
}

@end
