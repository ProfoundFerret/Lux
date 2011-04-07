//
//  LPlayerVideo.h
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPlayerVideo : NSObject {
	NSWindow * window;
}
- (NSWindow *) window;
- (void) setupWindow;
- (NSRect) windowRect;
- (void) updateSize;
- (void) setupView;
- (void) showWindow;
- (void) hideWindow;
- (void) setFullscreen:(BOOL)fullscreen;
@end
