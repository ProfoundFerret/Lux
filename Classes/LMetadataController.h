//
//  LMetadataController.h
//  Lux
//
//  Created by Kyle Carson on 3/15/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LControllerObject.h"
#import "LExtension.h"
#import "LFile.h"

@interface LMetadataController : LControllerObject {
    
}
- (void) parseMetadataForFile: (LFile *) file;
- (void) _parseMetadataForFile:(LFile *)file;
- (NSArray *) extensions;
@end
