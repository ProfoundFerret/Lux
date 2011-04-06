//
//  LPlayerVideo.m
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "LPlayerVideo.h"
#import "LFileController.h"
#import "Lux.h"

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
	
	[window makeKeyAndOrderFront:NSApp];
	NSView * view = [window contentView];
	[view setAutoresizesSubviews:YES];
	return window;
}

- (void) setupWindow
{
    NSNumber *height = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kHEIGHT];
    NSNumber *width = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kWIDTH];
    NSNumber *ratio = [NSNumber numberWithInt:0];
    
    NSLog(@" h = %f , w = %f",[height floatValue],[width floatValue]);
    
    if ([height floatValue] < 50.0 || [width floatValue] < 50.0) {
        NSLog(@"size is not good !");
        height = [NSNumber numberWithFloat:300.0];
        width = [NSNumber numberWithFloat:300.0];
        ratio = [NSNumber numberWithInt:-1];
    }
    
	NSRect frame = NSMakeRect(([[NSScreen mainScreen] frame].size.width/2), [[NSScreen mainScreen] frame].size.height/2, [width floatValue], [height floatValue]);
	int mask = NSTitledWindowMask + NSResizableWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask;
	window  = [[NSWindow alloc] initWithContentRect:frame styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    
    if ([ratio intValue] == 0) [window setAspectRatio:NSMakeSize([width floatValue], [height floatValue])];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setMovableByWindowBackground:YES];
    [window setOpaque:NO];
    
    LFile * activeFile = [[LFileController sharedInstance] activeFile];
    NSString * artist = [[activeFile attributes] objectForKey:kARTIST];
    NSString * title = [[activeFile attributes] objectForKey:kTITLE];
    
    if (activeFile) {
        if ([artist length])
        {
            [window setTitle:[NSString stringWithFormat:@"%@ %@ %@", title, kEM_DASH, artist]];
        } else {
            [window setTitle:title];
        }
    } else {
        [window setTitle:kNOTHING_PLAYING_TEXT];
    }
    
    [window makeKeyAndOrderFront:nil];
    
	[window retain];
}
@end
