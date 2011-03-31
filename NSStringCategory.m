//
//  NSStringCategory.m
//  Lux
//
//  Created by Kyle Carson on 3/31/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "NSStringCategory.h"


@implementation NSString (NSStringCategory)
- (NSString *) unCamelCasedString
{
	NSUInteger i;
	NSUInteger total = [self length];
	NSMutableString * newString = [[NSMutableString alloc] init];
	NSString * subString;
	NSString * capitalString;
	BOOL capitalizeNextCharacter = YES;
	for (i = 0; i < total; i++)
	{
		subString = [self substringWithRange:NSMakeRange(i, 1)];
		if ([subString isEqualToString:@"_"]) continue;
		
		capitalString = [subString capitalizedString];
		
		if ([subString isEqualToString:capitalString])
		{
			[newString appendString:@" "];
			capitalizeNextCharacter = YES;
		}
		if (capitalizeNextCharacter)
		{
			capitalizeNextCharacter = NO;
			subString = [subString capitalizedString];
		}
		[newString appendString:subString];
	}
	
	return [NSString stringWithString:newString];
}
@end
