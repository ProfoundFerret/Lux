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

#define kEXTENSIONS @"extensions"

@interface LExtensionController : LControllerObject {
	NSMutableArray * extensions;
}
- (void) loadDefaultExtensions;
- (BOOL) addExtension: (LExtension *) extension;
- (NSArray *) extensionsMatchingDelegate: (Protocol *) protocol;
@property (readonly, assign) NSMutableArray * extensions;
@end
