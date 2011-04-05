//
//  LMetadata_OtherFormats.h
//  Lux
//
//  Created by Adrien Bertrand on 05/04/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LExtension.h"

@interface LMetadata_OtherFormats : LExtension <LMetadataDelegate> {
@private
    
}

- (NSDictionary *) metadataForURL: (NSURL *) url; 
- (NSArray *) supportedMetadataExtensions;

@end
