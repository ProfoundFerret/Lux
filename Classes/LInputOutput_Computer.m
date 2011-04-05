//
//  LInputOutput_Computer.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LInputOutput_Computer.h"


@implementation LInputOutput_Computer

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSArray *) update
{
	NSMutableArray * files = [NSMutableArray array];
	NSFileManager * fileManager = [NSFileManager defaultManager];
	
	NSString * itemName;
	
	BOOL isDir;
	
	NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
	NSMutableArray * fileSearchLocations = [NSMutableArray arrayWithArray:[defaults arrayForKey:kFILE_SEARCH_LOCATIONS]];
	NSMutableArray * oldFileSearchLocations = [NSMutableArray array];
	
	NSString * path;
	
	while ([fileSearchLocations count])
	{
		path = [fileSearchLocations objectAtIndex:0];
		[fileSearchLocations removeObjectAtIndex:0];
		
		// Don't scan the same folder multiple times
		if ([oldFileSearchLocations containsObject:path])
		{
			NSLog(@"Already scanned %@.  Skipping", path);
			continue;
		}
		[oldFileSearchLocations addObject:path];
		
		NSArray * contents = [fileManager contentsOfDirectoryAtPath:path error:nil];
		for ( itemName in contents)
		{
			itemName = [NSString stringWithFormat:@"%@/%@", path, itemName];
			[fileManager fileExistsAtPath:itemName isDirectory:&isDir];
			
			if (isDir)
			{
				[fileSearchLocations addObject:itemName];
			} else {
				NSURL * url = [NSURL fileURLWithPath:itemName];
				[files addObject:url];
			}
		}
	}
	
	return [NSArray arrayWithArray:files];
}

- (NSDictionary *) defaultUserDefaults
{
	NSMutableDictionary * stdDefaults = [NSMutableDictionary dictionary];
	NSMutableArray * fileSearchLocations = [NSMutableArray array];
	[fileSearchLocations addObject:[kMUSIC_FOLDER_FOLDER stringByStandardizingPath]];
	
	[stdDefaults setObject:fileSearchLocations forKey:kFILE_SEARCH_LOCATIONS];
	
	return stdDefaults;
}

@end
