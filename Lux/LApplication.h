//
//  LApplication.h
//  Lux
//
//  Created by Kyle Carson on 4/1/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LApplication : NSApplication {
@private
    
}
- (void) mediaKeyEvent: (int) key state: (BOOL) keyDown repeat: (BOOL) repeat;
@end
