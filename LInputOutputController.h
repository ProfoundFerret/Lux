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

@interface LInputOutputController : LControllerObject {
    
}
- (NSArray *) extensions;

- (void) save;
- (void) load;
- (void) update;
@end
