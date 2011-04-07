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

- (void) showWindow
{
    if ([[[LFileController sharedInstance] activeFile] fileType] == LFileTypeVideo) {

        if (! window) [self setupWindow];
	
        [window makeKeyAndOrderFront:NSApp];
        NSView * view = [window contentView];
        [view setAutoresizesSubviews:YES];
        return window;
    } else {
        return nil;
    }
}

- (void) hideWindow
{
    NSNumber *height = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kHEIGHT];
    NSNumber *width = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kWIDTH];
    NSNumber *ratio = [NSNumber numberWithInt:0];
        
    if ([height floatValue] < 50.0 || [width floatValue] < 50.0) {
        height = [NSNumber numberWithFloat:300.0];
        width = [NSNumber numberWithFloat:300.0];
        ratio = [NSNumber numberWithInt:-1];
    }
    
	NSRect frame = NSMakeRect(([[NSScreen mainScreen] frame].size.width/2)-[width floatValue]/2, [[NSScreen mainScreen] frame].size.height/2-[height floatValue]/2, [width floatValue]+20, [height floatValue]);
	int mask = NSTitledWindowMask + NSResizableWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask;
	window  = [[NSWindow alloc] initWithContentRect:frame styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    
    if ([ratio intValue] == 0) [window setAspectRatio:NSMakeSize([width floatValue], [height floatValue])];
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setMovableByWindowBackground:YES];
    [window setAllowsConcurrentViewDrawing:NO];
    
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
	
	[self updateSize];
	
	return window;
}

- (void) updateSize
{
	NSRect rect = [self windowRect];
	
	CGFloat height = rect.size.height;
	CGFloat width = rect.size.width;
	
	if (height && width)
	{
		[window setAspectRatio:rect.size];
	}
}

- (NSRect) windowRect
{
    LFile * activeFile = [[LFileController sharedInstance] activeFile];
	NSNumber * width = [[activeFile attributes] objectForKey:kWIDTH];
	NSNumber * height = [[activeFile attributes] objectForKey:kHEIGHT];  
	
    if ([height floatValue] < 50.0 || [width floatValue] < 50.0) {
        height = [NSNumber numberWithFloat:300.0];
        width = [NSNumber numberWithFloat:300.0];
    }
	
	NSScreen * screen = [NSScreen mainScreen];
	
	NSRect frame = NSMakeRect(([screen frame].size.width/2)-[width floatValue]/2, [screen frame].size.height/2-[height floatValue]/2, [width floatValue]+20, [height floatValue]);
	
	return frame;
}

- (void) setupWindow
{
	if (window) return;
	
	int mask = NSTitledWindowMask + NSResizableWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask;
	NSRect frame = [self windowRect];
	window  = [[NSWindow alloc] initWithContentRect:frame styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    
    [window setBackgroundColor:[NSColor blackColor]];
    [window setMovableByWindowBackground:YES];
    
	[window retain];
	
	[self setupView];
}

- (void) setupView
{
	NSView * view = [window contentView];
	[view setAutoresizesSubviews:YES];
	[view drawRect:[view frame]];
}

- (void) setFullscreen:(BOOL)fullscreen
{
	[self window];
	BOOL currentFullscreen = [[window contentView] isInFullScreenMode];
	if (currentFullscreen == fullscreen) return;
	if (fullscreen)
	{
		NSArray *objects = [NSArray arrayWithObjects: [NSNumber numberWithUnsignedInt:(1 << 1)], [NSNumber numberWithUnsignedInt:(1 << 2)], nil];
		NSArray *keys = [NSArray arrayWithObjects: NSFullScreenModeApplicationPresentationOptions, NSFullScreenModeApplicationPresentationOptions, nil];
		NSDictionary * options = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
		
		[window setFrame:[window frameRectForContentRect:[[window screen] frame]] display:YES animate:YES];	
		[[window contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:options];
		[NSApp setPresentationOptions:NSApplicationPresentationAutoHideMenuBar | NSApplicationPresentationHideDock];
	} else
	{
		NSRect frame = [self windowRect];
		[[window contentView] exitFullScreenModeWithOptions:nil];
		[window setFrame:[window frameRectForContentRect:frame] display:YES animate:YES];
		[NSApp setPresentationOptions:NSApplicationPresentationDefault];
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kFULLSCREEN_CHANGED object:nil];
}
@end
