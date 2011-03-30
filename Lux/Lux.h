//
//  Lux.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSingleton.h"

#import "LuxAppDelegate.h"

#import "LExtensionController.h"
#import "LInputOutputController.h"
#import "LFileController.h"
#import "LPlaylistController.h"
#import "LPlayerController.h"

#define kIO_CONTROLLER @"ioController"
#define kPLAYER_CONTROLLER @"playerController"
#define kPLAYLIST_CONTROLLER @"playlistController"
#define kFILE_CONTROLLER @"fileController"
#define kEXTENSION_CONTROLLER @"extensionController"

#define kVOLUME @"volume"
#define kRELOAD_DATA_NOTIFICATION @"reloadData_notification"
#define kPLAYLIST_VISIBLE_CHANGED_NOTIFICATION @"playlistVisibleChanged_notification"
#define kPLAYLIST_ACTIVE_CHANGED_NOTIFICATION @"playlistActiveChanged_notification"

#define kEM_DASH @"—"

@interface Lux : LSingleton {
    LExtensionController * extensionController;
    LInputOutputController * ioController;
	LFileController * fileController;
	LPlaylistController * playlistController;
	LPlayerController * playerController;
}

- (void) setup;
- (void) reloadData;
- (void) registerUserDefaults;

@property (readonly) LExtensionController * extensionController;
@property (readonly) LInputOutputController * ioController;
@property (readonly) LFileController * fileController;
@property (readonly) LPlayerController * playerController;
@property (readonly) LPlaylistController * playlistController;
@end
