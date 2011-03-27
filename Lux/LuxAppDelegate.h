//
//  LuxAppDelegate.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Growl/Growl.h>


@interface LuxAppDelegate : NSObject <NSApplicationDelegate> {

	NSWindow *window;

}

@property (assign) IBOutlet NSWindow *window;

@end
