//
//  LGuiObject.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LGuiObject.h"


@implementation LGuiObject

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

- (void) reloadData
{
	NSLog(@"%@ hasn't implemented -reloadData", [self class]);
}

- (NSMenu *) menuForEvent: (NSEvent *) event
{
	return [[[NSMenu alloc] init] autorelease];
}
@end
