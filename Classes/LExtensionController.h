//
//  LExtensionController.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LExtension.h"

@class LPlaylist;

@interface LExtensionController : LControllerObject {
	NSMutableArray * extensions;
}
- (void) loadDefaultExtensions;
- (BOOL) addExtension: (LExtension *) extension;
- (NSArray *) extensionsMatchingDelegate: (Protocol *) protocol;

- (NSArray *) menuItemsForFiles: (NSArray *) files;
- (NSArray *) menuItemsForPlaylist: (LPlaylist *) playlist;
@property (readonly, assign) NSMutableArray * extensions;
@end
