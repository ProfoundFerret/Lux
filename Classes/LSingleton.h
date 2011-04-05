//
//  LSingleton.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LStoredObject.h"

@interface LSingleton : LStoredObject {
    
}
+ (id) sharedInstance;
@end
