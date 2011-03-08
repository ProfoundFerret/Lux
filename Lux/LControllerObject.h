//
//  LControllerObject.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSingleton.h"
#import "LGuiObject.h"

@interface LControllerObject : LSingleton {
	NSMutableArray * guis;
}
- (void) reloadData;
- (void) addGui: (LGuiObject *) gui;
@end
