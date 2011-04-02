//
//  LApplication.m
//  Lux
//
//  Created by Kyle Carson on 4/1/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "LApplication.h"
#import <IOKit/hidsystem/ev_keymap.h>
#import "LPlayerController.h"

@implementation LApplication

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
/*
- (void) mediaKeyEvent: (int) key state: (BOOL) keyDown repeat: (BOOL) repeat
{
	switch (key) {
		case NX_KEYTYPE_PLAY:
			if (keyDown == NO)
			{
				[[LPlayerController sharedInstance] playPause];
			}
			break;
		case NX_KEYTYPE_FAST:
			if (keyDown == NO)
			{
				[[LPlayerController sharedInstance] playNextFile];
			}
			break;
		case NX_KEYTYPE_REWIND:
			if (keyDown == NO)
			{
				[[LPlayerController sharedInstance] playPreviousFile];
			}
			break;
	}
}

- (void) sendEvent:(NSEvent *)event
{
	if ([event type] == NSSystemDefined && [event subtype] == NX_SUBTYPE_AUX_CONTROL_BUTTONS)
	{
		int keyCode = (([event data1] & 0xFFFF0000) >> 16);
		int keyFlags = ([event data1] & 0x0000FFFF);
		int keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA;
		
		[self mediaKeyEvent:keyCode state:keyState repeat:NO];
	}
	
	[super sendEvent:event];
}
 */
@end
