//
//  LDefinitions.h
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//


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

#define kPLAY_TEXT @"Play"
#define kPAUSE_TEXT @"Pause"
#define kNEXT_TEXT @"Next"
#define kPREVIOUS_TEXT @"Previous"
#define kPLAY_RECENT_TEXT @"Play Recent"
#define kREPEAT_TEXT @"Repeat"
#define kSHUFFLE_TEXT @"Shuffle"
#define kIT_IS_PAUSED @"(Paused)"
#define kSHOW_IN_FINDER_TEXT @"Show In Finder"
#define kSHOW_IN_PLAYLIST @"Show In Playlist"
#define kADD_TO_PLAYLIST_TEXT @"Add To Playlist"
#define kNEW_PLAYLIST @"New Playlist"
#define kDELETE_FROM_TEXT @"Delete From"
#define kDELETE_FROM_LIBRARY_TEXT @"Delete From Library"

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

#define kUNTITLED_PLAYLIST @"Untitled Playlist"

#define kSMART_SEARCH_DELIMITER @"?"

#define kMUSIC @"Music"
#define kVIDEO @"Video"
#define kSTREAMING @"Streaming"

#define ZERO [NSNumber numberWithInt:0]

#define kPLAYLISTS @"Playlists"
#define kLIBRARY @"Library"
#define kACTIVE_PLAYLIST @"activePlaylist"
#define kVISIBLE_PLAYLIST @"visiblePlaylist"

#define kDUPLICATE_TEXT @"Duplicate"
#define kDELETE_TEXT @"Delete"
#define kCONVERT_TO_REGULAR_PLAYLIST_TEXT @"Convert to Regular Playlist"
#define kRENAME_TEXT @"Rename"

#define NS_TABLE_COLUMN @"NSTableColumn"