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

#define kINDEX @"index"
#define kTITLE @"title"
#define kARTIST @"artist"
#define kALBUM @"album"
#define kTIME @"time"
#define kGENRE @"genre"
#define kRATING @"rating"
#define kPLAY_COUNT @"play count"
#define kLAST_PLAY_DATE @"last play date"
#define kADD_DATE @"add date"
#define kYEAR @"year"

#define kKEEPER_ATTRIBUTES [NSArray arrayWithObjects:kTITLE, kARTIST, kALBUM, kTIME, kGENRE, kRATING, kPLAY_COUNT, kLAST_PLAY_DATE, kADD_DATE, kYEAR, nil]

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
 kRATING: 0 through 10 (NSNumber),
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

- (LFileType) fileTypeForExtension: (NSString *) extension; // FileType representing extension
- (NSArray *) supportedExtensions; // NSArray of all supported extensions in lower case
@end

@interface LExtension : LStoredObject {
@private
    
}
- (NSDictionary *) defaultUserDefaults;
@end
