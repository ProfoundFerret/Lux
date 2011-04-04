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

#define kIMAGE @"image"

@interface LFile : LStoredObject {
    NSURL * url;
	NSMutableDictionary * attributes;
	NSString * searchAttributes;
	NSString * extension;
	LFileType fileType;
	
	NSMutableDictionary * dictionary;
	NSMutableDictionary * lowercaseDictionary;
}
- (NSString *) extension;

- (NSString *) searchAttributes;

- (id) formatedAttributeForIdentifier: (id) identifier;

- (void) resetCachedData;

- (LFileType) fileType;
- (void) updateMetadata;

- (NSDictionary *) dictionary;
- (NSDictionary *) lowercaseDictionary;

@property (readwrite, assign) NSURL * url;
@property (readwrite, assign) NSMutableDictionary * attributes;
@property (readwrite, assign, nonatomic) NSString * extension;
@end
