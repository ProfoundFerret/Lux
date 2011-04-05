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


#pragma mark Localized

#define kFILES_COUNT_TEXT NSLocalizedString(@"%d Files",nil)
#define kFILE_COUNT_TEXT NSLocalizedString(@"%d File",nil)
#define kPLAY_TEXT NSLocalizedString(@"Play",nil)
#define kPAUSE_TEXT NSLocalizedString(@"Pause",nil)
#define kNEXT_TEXT NSLocalizedString(@"Next",nil)
#define kPREVIOUS_TEXT NSLocalizedString(@"Previous",nil)
#define kPLAY_RECENT_TEXT NSLocalizedString(@"Play Recent",nil)
#define kREPEAT_TEXT NSLocalizedString(@"Repeat",nil)
#define kSHUFFLE_TEXT NSLocalizedString(@"Shuffle",nil)
#define kPAUSED_TEXT NSLocalizedString(@"(Paused)",nil)
#define kSHOW_IN_FINDER_TEXT NSLocalizedString(@"Show In Finder",nil)
#define kSHOW_IN_PLAYLIST_TEXT NSLocalizedString(@"Show In Playlist",nil)
#define kADD_TO_PLAYLIST_TEXT NSLocalizedString(@"Add To Playlist",nil)
#define kNEW_PLAYLIST_TEXT NSLocalizedString(@"New Playlist",nil)
#define kDELETE_FROM_TEXT NSLocalizedString(@"Delete From",nil)
#define kDELETE_FROM_LIBRARY_TEXT NSLocalizedString(@"Delete From Library",nil)
#define kDUPLICATE_TEXT NSLocalizedString(@"Duplicate",nil)
#define kDELETE_TEXT NSLocalizedString(@"Delete",nil)
#define kCONVERT_TO_REGULAR_PLAYLIST_TEXT NSLocalizedString(@"Convert to Regular Playlist",nil)
#define kRENAME_TEXT NSLocalizedString(@"Rename",nil)
#define kMUSIC_TEXT NSLocalizedString(@"Music",nil)
#define kVIDEO_TEXT NSLocalizedString(@"Video",nil)
#define kSTREAMING_TEXT NSLocalizedString(@"Streaming",nil)
#define kPLAYLISTS_TEXT NSLocalizedString(@"Playlists",nil)
#define kLIBRARY_TEXT NSLocalizedString(@"Library",nil)
#define kUNTITLED_PLAYLIST_TEXT  NSLocalizedString(@"Untitled Playlist",nil)
#define kNOTHING_PLAYING_TEXT NSLocalizedString(@"Nothing Playing",nil)
#define kFULLSCREEN_TEXT NSLocalizedString(@"Full Screen",nil)


#pragma mark Controllers

#define kIO_CONTROLLER @"ioController"
#define kPLAYER_CONTROLLER @"playerController"
#define kPLAYLIST_CONTROLLER @"playlistController"
#define kFILE_CONTROLLER @"fileController"
#define kEXTENSION_CONTROLLER @"extensionController"


#pragma mark Notifications

#define kREPEAT_CHANGED_NOTIFICATION @"repeatchanged_notification"
#define kSHUFFLE_CHANGED_NOTIFICATION @"shufflechanged_notification"
#define kRELOAD_DATA_NOTIFICATION @"reloadData_notification"
#define kPLAYLIST_VISIBLE_CHANGED_NOTIFICATION @"playlistVisibleChanged_notification"
#define kPLAYLIST_ACTIVE_CHANGED_NOTIFICATION @"playlistActiveChanged_notification"
#define kBEGIN_EDITING_PLAYLIST_NOTIFICATION @"beginEditingPlaylist_notification"
#define kSELECT_FILES_NOTIFICATION @"selectFiles_notification"
#define kUNPAUSE_NOTIFICATION @"unpause_notification"
#define kPAUSE_NOTIFICATION @"unpause_notification"
#define kPLAY_NOTIFICATION @"play_notification"
#define kSTOP_NOTIFICATION @"stop_notification"


#pragma mark Characters

#define kEM_DASH [NSString stringWithFormat: @"%C", 0x2014]
#define kSTAR [NSString stringWithFormat:@"%C", 0x2605]
#define kHALF_STAR [NSString stringWithFormat:@"%C", 0x00BD]
#define kNO_STAR [NSString stringWithFormat:@"%C",0x00B7]
#define kSMART_SEARCH_DELIMITER @"?"


#pragma mark Numbers

#define kMAX_RECENT_FILES 10
#define kVOLUME_INCREMENT .08
#define kTIME_INCREMENT 1000 * 5
#define kTIME_SCRUB_FREQUENCY 0.4
#define kMARGIN_SIZE 4
#define kNO_LIMIT -1
#define ZERO [NSNumber numberWithInt:0]
#define kMIN_SPLIT_SIZE 175
#define kAUTOSAVE_INTERVAL 10.0


#pragma mark Code

#define kKEEPER_ATTRIBUTES [NSArray arrayWithObjects:kTITLE, kARTIST, kALBUM, kTIME, kGENRE, kRATING, kPLAY_COUNT, kLAST_PLAY_DATE, kADD_DATE, kYEAR, nil]


#pragma mark General

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

#define kACTIVE_PLAYLIST @"activePlaylist"
#define kVISIBLE_PLAYLIST @"visiblePlaylist"

#define NS_TABLE_COLUMN @"NSTableColumn"

#define kSPLITVIEW_NAME @"MainSplitView"