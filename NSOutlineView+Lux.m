//
//  NSOutlineView+Lux.m
//  Lux
//
//  Created by Kyle Carson on 3/10/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "NSOutlineView+Lux.h"


@implementation NSOutlineView (NSOutlineView_Lux)
- (void)expandParentsOfItem:(id)item {
    while (item != nil) {
        id parent = [self parentForItem: item];
        if (![self isExpandable: parent])
            break;
        if (![self isItemExpanded: parent])
            [self expandItem: parent];
        item = parent;
    }
}

- (void)selectItem:(id)item {
    NSInteger itemIndex = [self rowForItem:item];
    if (itemIndex < 0) {
        [self expandParentsOfItem: item];
        itemIndex = [self rowForItem:item];
        if (itemIndex < 0)
            return;
    }
	
    [self selectRowIndexes: [NSIndexSet indexSetWithIndex: itemIndex] byExtendingSelection: NO];
}
@end
