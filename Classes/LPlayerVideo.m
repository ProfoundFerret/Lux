//
//  LPlayerVideo.m
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "LPlayerVideo.h"


@implementation LPlayerVideo

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

- (NSWindow *) window
{
	if (! window) [self setupWindow];
	
	NSView * view = [window contentView];
	[view setAutoresizesSubviews:YES];
	return window;
}

- (void) setupWindow
{
	NSRect frame = NSMakeRect(0, 0, 200, 200);
	int mask = NSTitledWindowMask + NSResizableWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask;
	window  = [[NSWindow alloc] initWithContentRect:frame styleMask:mask backing:NSBackingStoreBuffered defer:NO];
	[window makeKeyAndOrderFront:NSApp];
}
@end
