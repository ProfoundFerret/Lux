//
//  LInputOutputController.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"

#define kSAVE_FILE [@"~/Music/LuxData.plist" stringByExpandingTildeInPath]
#define kAUTOSAVE_INTERVAL 10.0

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