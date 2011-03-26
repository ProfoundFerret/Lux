//
//  LFileController.m
//  Lux
//
//  Created by Kyle Carson on 3/8/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LFileController.h"
#import "Lux.h"

#define kPLAY_TEXT @"Play"
#define kSHOW_IN_FINDER_TEXT @"Show In Finder"

@implementation LFileController
@synthesize activeFile;
- (id)init
{
    self = [super init];
    if (self) {
		files = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
	[files dealloc];
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	files = [[aDecoder decodeObjectForKey:kFILES] retain];
	
	return [self retain];
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
	[aCoder encodeObject:files forKey:kFILES];
	
	[super encodeWithCoder:aCoder];
}

- (NSDictionary *) files
{
	return [NSDictionary dictionaryWithDictionary:files];
}

- (LFile *) createFileByURL: (NSURL *) url;
{
	LFile * f = [[LFile alloc] init];
	[f setUrl:url];
	
	return [f autorelease];
}

- (BOOL) addFileByFile: (LFile *) file
{
	if (! file) return NO;
	if ([files objectForKey:[file url]]) return NO;
	if ([file fileType] == LFileTypeUnknown) return NO;
	
	[files setObject:file forKey:[file url]];
	[file updateMetadata];
	
	return YES;
}

- (void) addFilesByURL: (NSArray *) fileURLs
{
	for (NSURL * url in fileURLs)
	{
		[self addFileByURL:url];
	}
}

- (void) addFileByURL: (NSURL *) url
{
	LFile * f = [[self createFileByURL:url] retain];
	[self addFileByFile:f];
}

- (LFileType) fileTypeForFile:(LFile *)file
{
	static NSMutableDictionary * fileTypesForFiles;
	if (! fileTypesForFiles)
	{
		fileTypesForFiles = [[NSMutableDictionary alloc] init];
	}
	NSString * fileExtension = [file extension];
	if (! [fileTypesForFiles objectForKey:fileExtension])
	{
		LExtension <LPlayerDelegate> * player = [[[Lux sharedInstance] playerController] playerForFile:file];
		
		if (player)
		{
			NSNumber * fileType = [NSNumber numberWithInt:[player fileTypeForExtension:fileExtension]];
		
			[fileTypesForFiles setObject:fileType forKey:fileExtension];
		}
	}
	return [[fileTypesForFiles objectForKey:fileExtension] intValue];
}

- (void) fileFinishedPlaying: (LFile *)file
{
	NSNumber * number = [[file attributes] objectForKey:kPLAY_COUNT];
	int increment = [number intValue] + 1;
	number = [NSNumber numberWithInt:increment];
	[[file attributes] setObject:number forKey:kPLAY_COUNT];
}
- (void) fileStartedPlaying: (LFile *)file
{

}

- (NSMenu *) menuForFiles: (NSArray *) menuFiles
{
	NSMenu * menu = [[[NSMenu alloc] init] autorelease];
	[menu setAutoenablesItems:NO];
	
	NSMenuItem * play = [[[NSMenuItem alloc] init] autorelease];
	NSString * title = [[[menuFiles objectAtIndex:0] attributes] objectForKey:kTITLE];
	NSString * playText = [NSString stringWithFormat:@"%@ \"%@\"", kPLAY_TEXT, title];
	[play setTitle:playText];
	[play setTarget:[LPlayerController sharedInstance]];
	[play setRepresentedObject:[menuFiles objectAtIndex:0]];
	[play setAction:@selector(playMenuItem:)];
	[menu addItem:play];
	
	//[menu addItem:[NSMenuItem separatorItem]];
	
	//NSMenuItem * addToPlaylist = [[NSMenuItem alloc] init];
	
	[menu addItem:[NSMenuItem separatorItem]];
	
	NSMenuItem * finder = [[[NSMenuItem alloc] init] autorelease];
	[finder setTitle:kSHOW_IN_FINDER_TEXT];
	[finder setAction: @selector(showInFinder:)];
	[finder setTarget: self];
	[finder setRepresentedObject:menuFiles];
	[menu addItem:finder];
	
	return menu;
}

- (void) showInFinder: (NSMenuItem *) item
{
	for (LFile *file in [item representedObject])
	{
		NSString * path = [[file url] path];
		[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];
	}
}
@end
