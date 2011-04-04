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
@synthesize extensionController, fileController, ioController, playerController, playlistController;
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
	[aCoder encodeObject:extensionController forKey:kEXTENSION_CONTROLLER];
	[aCoder encodeObject:ioController forKey:kIO_CONTROLLER];
	[aCoder encodeObject:playerController forKey:kPLAYER_CONTROLLER];
	[aCoder encodeObject:fileController forKey:kFILE_CONTROLLER];
	[aCoder encodeObject:playlistController forKey:kPLAYLIST_CONTROLLER];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	extensionController = [aDecoder decodeObjectForKey:kEXTENSION_CONTROLLER];
	[self registerUserDefaults];

	ioController = [aDecoder decodeObjectForKey:kIO_CONTROLLER];
	playerController = [aDecoder decodeObjectForKey:kPLAYER_CONTROLLER];
	
	fileController = [aDecoder decodeObjectForKey:kFILE_CONTROLLER];
	playlistController = [aDecoder decodeObjectForKey:kPLAYLIST_CONTROLLER];
	
	[self reloadData];
	
	//[[_Test alloc] init];
	return [self retain];
}

- (void) setup
{
    NSLog(@"setup start...");
 
    ioController = [LInputOutputController sharedInstance];
	[ioController load];
	
    extensionController = [LExtensionController sharedInstance];
	[self registerUserDefaults];
	
	playerController = [LPlayerController sharedInstance];
	
	fileController = [LFileController sharedInstance];
	playlistController = [LPlaylistController sharedInstance];
    	
	[ioController update];

    NSLog(@"setup done...");

}

- (NSDictionary *)registrationDictionaryForGrowl {
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Growl Registration Ticket" ofType:@"growlRegDict"]];
}

- (void) reloadData
{
	[playlistController reloadData];
	[fileController reloadData];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:kRELOAD_DATA_NOTIFICATION object:nil];
	
	[ioController setNeedsSaved:YES];
}

- (void) registerUserDefaults
{
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	
	NSMutableDictionary * stdDefaults = [NSMutableDictionary dictionary];
	
	[stdDefaults setValue:[NSNumber numberWithDouble:0.5] forKey:kVOLUME];
	
	for (LExtension * extension in [extensionController extensions])
	{
		[stdDefaults addEntriesFromDictionary:[extension defaultUserDefaults]];
	}
	
	[defaults registerDefaults:stdDefaults];
}
@end
