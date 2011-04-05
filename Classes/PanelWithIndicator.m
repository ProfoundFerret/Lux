//
//  PanelWithIndicator.m
//  PanelWithIndicator
//
//  Created by Vladimir Boychentsov on 10/14/10.
//  Copyright 2010 www.injoit.com. All rights reserved.
//

#import "PanelWithIndicator.h"


@implementation PanelWithIndicator


- (NSString*)windowNibName
{
	return @"Panel";
}

- (void) awakeFromNib {
	[indicator startAnimation:self];
}

- (void)withParentWindow:parentWindow
{
	NSWindow* window = [self window];
	
	[NSApp beginSheet:window modalForWindow:parentWindow modalDelegate:nil didEndSelector:nil contextInfo:nil];
	[NSApp runModalForWindow:window];
	// sheet is up now...
	
	[NSApp endSheet:window];
	[window orderOut:self];
	
}


- (void) end {
	[[self window] orderOut:nil];
	[NSApp stopModal];
}

@end
