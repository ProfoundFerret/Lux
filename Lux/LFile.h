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

@interface LFile : LStoredObject {
    NSURL * url;
	NSMutableDictionary * attributes;
	NSArray * searchAttributes;
}
- (NSString *) extension;

- (BOOL) matchesSearchSet: (NSArray *) searchSet;
- (BOOL) searchSubstringIsValid: (NSString *) string;

- (NSArray *) searchAttributes;

- (id) attributeForIdentifier: (id) identifier;

- (LFileType) fileType;

- (NSDictionary *) dictionary;

@property (readwrite, assign) NSURL * url;
@property (readwrite, assign) NSMutableDictionary * attributes;
@end
