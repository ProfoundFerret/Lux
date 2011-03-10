//
//  Lux.m
//  Lux
//
//  Created by Kyle Carson on 3/7/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "Lux.h"
#import "LExtension.h"
#import "_Test.h"

@implementation Lux
@synthesize extensionController, fileController, ioController;
- (id)init
{
    self = [super init];
	
    if (self) {
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:ioController forKey:kIO_CONTROLLER];
	//[aCoder encodeObject:playerController forKey:kPLAYER_CONTROLLER];
	[aCoder encodeObject:playlistController forKey:kPLAYLIST_CONTROLLER];
	[aCoder encodeObject:fileController forKey:kFILE_CONTROLLER];
	[aCoder encodeObject:extensionController forKey:kEXTENSION_CONTROLLER];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [Lux sharedInstance];

	ioController = [aDecoder decodeObjectForKey:kIO_CONTROLLER];
	//playerController = [aDecoder decodeObjectForKey:kPLAYER_CONTROLLER];
	playlistController = [aDecoder decodeObjectForKey:kPLAYLIST_CONTROLLER];
	fileController = [aDecoder decodeObjectForKey:kFILE_CONTROLLER];
	extensionController = [aDecoder decodeObjectForKey:kEXTENSION_CONTROLLER];
	
	[self registerUserDefaults];
	[self reloadData];
	
	[[_Test alloc] init];
	return [self retain];
}

- (void) setup
{
    extensionController = [LExtensionController sharedInstance];
	[self registerUserDefaults];
	
	ioController = [LInputOutputController sharedInstance];
	fileController = [LFileController sharedInstance];
	
	[ioController load];
	[ioController update];
}

- (void) reloadData
{
	[[NSNotificationCenter defaultCenter] postNotificationName:@"reloadData" object:nil];
}

- (void) registerUserDefaults
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary * stdDefaults = [NSMutableDictionary dictionary];
	
	[stdDefaults setValue:[NSNumber numberWithDouble:0.5] forKey:@"volume"];
	
	for (LExtension * extension in [extensionController extensions])
	{
		[stdDefaults addEntriesFromDictionary:[extension defaultUserDefaults]];
	}
	
	[defaults registerDefaults:stdDefaults];
}
@end
