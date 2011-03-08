//
//  LExtensionController.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LExtensionController.h"
#import	"LExtension.h"

//
#import "LInputOutput_Computer.h"
//

#define kEXTENSIONS @"extensions"

@implementation LExtensionController
@synthesize extensions;
- (id)init
{
    self = [super init];
    if (self) {
		extensions = [[NSMutableArray alloc] init];
		
		[self addExtension: [[LInputOutput_Computer alloc] init]];
    }
    
    return self;
}

- (void)dealloc
{
	[extensions dealloc];
    [super dealloc];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject: extensions forKey:kEXTENSIONS];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	extensions = [[aDecoder decodeObjectForKey:kEXTENSIONS] retain];
	return self;
}

- (BOOL) addExtension: (LExtension *) extension
{
	if ([extensions containsObject:extension]) return NO;
	[extensions addObject:extension];
	return YES;
}

- (NSArray *) extensionsMatchingDelegate: (Protocol *) protocol
{
	NSMutableArray * exts = [NSMutableArray array];
	for (LExtension * ext in extensions)
	{
		if ([[ext class] conformsToProtocol:protocol]) [exts addObject:ext];
	}
	return [NSArray arrayWithArray:exts];
}
@end
