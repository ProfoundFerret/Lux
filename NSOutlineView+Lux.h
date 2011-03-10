//
//  NSOutlineView+Lux.h
//  Lux
//
//  Created by Kyle Carson on 3/10/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSOutlineView (NSOutlineView_Lux)
- (void) expandParentOfItem:(id)item;
- (void) expandItem:(id)item;
@end
