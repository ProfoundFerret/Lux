//
//  LTableView.m
//  Lux
//
//  Created by Kyle Carson on 3/24/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LTableView.h"
#import "LFileController.h"
#import "LPlaylistController.h"
#import "LGuiObject.h"

@implementation LTableView

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
		LGuiObject <NSTableViewDelegate> * delegate = [self delegate];
		return [delegate menuForEvent: event];
	}
	return [LTableView defaultMenu];
}

-(void)keyDown:(NSEvent *)theEvent {
    NSLog(@"MyTableView: keyDown: %c", [[theEvent characters] characterAtIndex:0]);
    [super keyDown:theEvent];
}

@end
