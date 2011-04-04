//
//  LDefinitions.h
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#define DEV

#ifdef DEV
#define kSAVE_FILE [@"~/Music/DevLuxData.plist" stringByExpandingTildeInPath]
#else
#define kSAVE_FILE [@"~/Music/LuxData.plist" stringByExpandingTildeInPath]
#endif

#define kAUTOSAVE_INTERVAL 10.0

#define kIO_CONTROLLER @"ioController"
#define kPLAYER_CONTROLLER @"playerController"
#define kPLAYLIST_CONTROLLER @"playlistController"
#define kFILE_CONTROLLER @"fileController"
#define kEXTENSION_CONTROLLER @"extensionController"

#define kRELOAD_DATA_NOTIFICATION @"reloadData_notification"
#define kPLAYLIST_VISIBLE_CHANGED_NOTIFICATION @"playlistVisibleChanged_notification"
#define kPLAYLIST_ACTIVE_CHANGED_NOTIFICATION @"playlistActiveChanged_notification"
#define kBEGIN_EDITING_PLAYLIST_NOTIFICATION @"beginEditingPlaylist_notification"
#define kSELECT_FILES_NOTIFICATION @"selectFiles_notification"
#define kUNPAUSE_NOTIFICATION @"unpause_notification"
#define kPAUSE_NOTIFICATION @"unpause_notification"
#define kPLAY_NOTIFICATION @"play_notification"
#define kSTOP_NOTIFICATION @"stop_notification"
#define kNOTHING_PLAYING @"Nothing Playing"

#define kEM_DASH [NSString stringWithFormat: @"%C", 0x2014]
#define kSTAR [NSString stringWithFormat:@"%C", 0x2605]
#define kHALF_STAR [NSString stringWithFormat:@"%C", 0x2729]

#define kINDEX @"index"
#define kTITLE @"title"
#define kARTIST @"artist"
#define kALBUM @"album"
#define kTIME @"time"
#define kGENRE @"genre"
#define kRATING @"rating"
#define kPLAY_COUNT @"playCount"
#define kLAST_PLAY_DATE @"lastPlayDate"
#define kADD_DATE @"addDate"
#define kYEAR @"year"
#define kVOLUME @"volume"
#define kURL @"url"

#define kATTRIBUTES @"attributes"
#define kSEARCHATTRIBUTES @"searchAttributes"
#define kFILE_TYPE @"fileType"
#define kEXTENSION @"extension"
#define kFILES @"files"
#define kACTIVE_FILE @"activeFile"
#define kBLACKLIST_URLS @"blacklistURLs"

#define kEXTENSIONS @"extensions"
#define kRECENT_FILES @"recentFiles"

#define kKEEPER_ATTRIBUTES [NSArray arrayWithObjects:kTITLE, kARTIST, kALBUM, kTIME, kGENRE, kRATING, kPLAY_COUNT, kLAST_PLAY_DATE, kADD_DATE, kYEAR, nil]

#define kMAX_RECENT_FILES 10
#define kVOLUME_INCREMENT .08
#define kTIME_INCREMENT 1000 * 5
#define kTIME_SCRUB_FREQUENCY 0.4

#define kFILES_COUNT_TEXT @"%d Files"
#define kFILE_COUNT_TEXT @"%d File"
#define kMARGIN_SIZE 4

#define kMEMBERS @"members"
#define kPLAYLIST_TITLE @"playlistTitle"
#define kSEARCH @"search"
#define kSMART @"smart"
#define kPREDICATE @"predicate"
#define kWRITE @"write"
#define kCOLUMNS @"columns"
#define kSELECTED_FILES @"selectedFiles"
#define kREPEAT @"repeat"
#define kSHUFFLE @"shuffle"
#define kSORT @"sort"
#define kDESCENDING @"descending"
#define kNEEDS_SORTED @"needsSorted"
#define kLIMIT @"limit"

#define kREPEAT_CHANGED_NOTIFICATION @"repeatchanged_notification"
#define kSHUFFLE_CHANGED_NOTIFICATION @"shufflechanged_notification"

#define kNO_LIMIT -1

#define kSMART_SEARCH_DELIMITER @"?"

#define ZERO [NSNumber numberWithInt:0]
#define kACTIVE_PLAYLIST @"activePlaylist"
#define kVISIBLE_PLAYLIST @"visiblePlaylist"

#define NS_TABLE_COLUMN @"NSTableColumn"


#import "LLocalization.h"