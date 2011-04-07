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

- (void) hideWindow
{
	[window orderOut:NSApp];
}

- (void) showWindow
{
	[window makeKeyAndOrderFront:NSApp];
	[self setupView];
}

- (void) setupWindow
{
	if (window) return;
	
	int mask = NSTitledWindowMask + NSResizableWindowMask + NSClosableWindowMask + NSMiniaturizableWindowMask;
	NSRect frame = [self windowRect];
	window  = [[NSWindow alloc] initWithContentRect:frame styleMask:mask backing:NSBackingStoreBuffered defer:NO];
    
    [window setOpaque:NO];
    [window setBackgroundColor:[NSColor blackColor]];
    [window setMovableByWindowBackground:YES];
    [window setAllowsConcurrentViewDrawing:NO];
    
    [self setupView];
	
	[window retain];
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
		unsigned int presentationOptions = NSApplicationPresentationAutoHideMenuBar | NSApplicationPresentationHideDock;
        [window setFrame:[window frameRectForContentRect:[[window screen] frame]] display:YES
         animate:YES];
        [[window contentView] enterFullScreenMode:[NSScreen mainScreen] withOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInt:presentationOptions] forKey:NSFullScreenModeApplicationPresentationOptions]];
		
		[NSApp setPresentationOptions:presentationOptions];
	} else {
        NSNumber *height = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kHEIGHT];
        NSNumber *width = [[[[LFileController sharedInstance] activeFile] attributes] objectForKey:kWIDTH];
		
        if ([height floatValue] < 50.0 || [width floatValue] < 50.0) {
            height = [NSNumber numberWithFloat:300.0];
            width = [NSNumber numberWithFloat:300.0];
        }
        
		NSRect frame = [self windowRect];
        [[window contentView] exitFullScreenModeWithOptions:nil];
        [window setFrame:[window frameRectForContentRect:frame] display:YES animate:YES];
        [NSApp setPresentationOptions:NSApplicationPresentationDefault];
    }
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kFULLSCREEN_CHANGED object:nil];
}

@end
