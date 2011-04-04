//
//  PanelWithIndicator.h
//  PanelWithIndicator
//
//  Created by Vladimir Boychentsov on 10/14/10.
//  Copyright 2010 www.injoit.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PanelWithIndicator : NSWindowController {
	IBOutlet NSProgressIndicator *indicator;
}

- (void) end;
- (void)withParentWindow:parentWindow;

@end
