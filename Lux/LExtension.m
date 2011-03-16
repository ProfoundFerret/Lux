//
//  LExtension.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LExtension.h"


@implementation LExtension

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

- (NSDictionary *) defaultUserDefaults
{
	return [NSDictionary dictionary];
}

- (int) majorVersion
{
	return 0;
}

- (int) minorVersion
{
	return 0;
}
@end
