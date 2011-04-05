//
//  LOutlineView.m
//  Lux
//
//  Created by Kyle Carson on 3/27/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "LOutlineView.h"
#import "LGuiObject.h"

@implementation LOutlineView

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

- (NSMenu *) menuForEvent: (NSEvent *) event
{
	if ([[self delegate] respondsToSelector:@selector(menuForEvent:)])
	{
		LGuiObject <NSOutlineViewDelegate> * delegate = [self delegate];
		return [delegate menuForEvent: event];
	}
	return [LOutlineView defaultMenu];
}

@end
