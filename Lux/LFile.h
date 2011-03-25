//
//  LFile.h
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LStoredObject.h"
#import "LFileType.h"

#define kURL @"url"
#define kATTRIBUTES @"attributes"
#define kSEARCHATTRIBUTES @"searchAttributes"
#define kFILE_TYPE @"fileType"
#define kEXTENSION @"extension"

@interface LFile : LStoredObject {
    NSURL * url;
	NSMutableDictionary * attributes;
	NSArray * searchAttributes;
	NSString * extension;
	
	NSDictionary * dictionary;
}
- (NSString *) extension;

- (BOOL) matchesSearchSet: (NSArray *) searchSet;
- (BOOL) searchSubstringIsValid: (NSString *) string;

- (NSArray *) searchAttributes;

- (id) attributeForIdentifier: (id) identifier;

- (LFileType) fileType;
- (void) updateMetadata;

- (NSDictionary *) dictionary;

- (NSArray *) playlists;

@property (readwrite, assign) NSURL * url;
@property (readwrite, assign) NSMutableDictionary * attributes;
@property (readwrite, assign, nonatomic) NSString * extension;
@end
