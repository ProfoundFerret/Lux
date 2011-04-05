//
//  LExtension.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LStoredObject.h"
#import "LFileType.h"

@class LPlaylist;

@protocol LInputOutputDelegate <NSObject>
- (NSArray *) update; // return an NSArray of all files' NSURLs
@end

@protocol LMetadataDelegate <NSObject>
/*
 Will be passed a NSURL of an item that doesn't have metadata.
 If parsing fails for some reason return nil
 NSDictionary should contain the following attributes if they exist:
 
 kTITLE (NSString)
 kARTIST (NSString),
 kALBUM (NSString),
 kTIME: in milliseconds (NSNumber),
 kGENRE (NSString),
 kCOMPOSER (NSString),
 kRATING: 0 through 5 (NSNumber),
 kPLAY_COUNT (NSNumber),
 kLAST_PLAY_COUNT (NSDate),
 kADD_DATE: only include if importing from another application (NSDate)
 kYEAR (NSNumber)
 
 ***Other attributes you wish to include must start with an underscore or they will not be saved***
 */
- (NSDictionary *) metadataForURL: (NSURL *) url; 
- (NSArray *) supportedMetadataExtensions;
@end

@protocol LPlayerDelegate <NSObject>
- (void) setAndPlayFile: (NSURL*) url withVolume: (double) volume; // Set the url, start playing it with a given volume
- (void) stop; // Playing should stop.  File progress, caching, etc can be reset as well.
- (void) play; // Play file (aka unpause).  File progress should remain.
- (void) pause; // Pause file.  File progress should remain.
- (void) setTime: (int) newTime; // Change the current time to newTime (given in milliseconds).  If playing before setTime then keep playing after
- (void) setVolume: (double) volume; // Change the volume.  volume ranges from 0 to 1.
- (int) currentTime; // Returns the current time in milliseconds
- (int) totalTime; // Returns the total time in milliseconds

- (LFileType) fileTypeForExtension: (NSString *) extension; // FileType representing extension, will only be run once per extension per application launch
- (NSArray *) supportedExtensions; // NSArray of all supported extensions in lower case

@optional
- (void) enterFullScreen;
- (void) exitFullScreen;
- (void) playVideoInView: (NSView *) view;
@end

@interface LExtension : LStoredObject <NSCoding> {
@private
    
}
- (NSDictionary *) defaultUserDefaults;
- (int) majorVersion;
- (int) minorVersion;
- (NSArray *) menuItemsForFiles: (NSArray *) files;
- (NSArray *) menuItemsForPlaylist: (LPlaylist *) playlist;
@end
