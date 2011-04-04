//
//  LInputOutputController.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LDefinitions.h"

@interface LInputOutputController : LControllerObject {
    BOOL loaded;
	BOOL needsSaved;
}
- (NSArray *) extensions;

- (void) save;
- (void) _save;
- (void) load;
- (void) update;
- (void) _update;
@property (readwrite, assign) BOOL needsSaved;
@end