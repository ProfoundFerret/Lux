//
//  Lux.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSingleton.h"

#import "LExtensionController.h"
#import "LInputOutputController.h"
#import "LFileController.h"

@interface Lux : LSingleton {
    LExtensionController * extensionController;
    LInputOutputController * ioController;
	LFileController * fileController;
}
- (void) setup;
- (void) reloadData;
- (void) registerUserDefaults;
@property (readonly) LExtensionController * extensionController;
@property (readonly) LInputOutputController * ioController;
@property (readonly) LFileController * fileController;
@end
