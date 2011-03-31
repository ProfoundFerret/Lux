//
//  NSArrayCategory.m
//  Lux
//
//  Created by Kyle Carson on 3/30/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "NSArrayCategory.h"


@implementation NSArray (NSArrayCategory)
- (NSIndexSet *) indexesForObjects: (NSArray *) array
{
	NSMutableIndexSet * indexSet = [NSMutableIndexSet indexSet];
	NSUInteger index;
	for (id obj in array)
	{
		index = [self indexOfObject:obj];
		if (index != NSNotFound) [indexSet addIndex:index];
	}
	return [[[NSIndexSet alloc] initWithIndexSet:indexSet] autorelease];
}
@end
