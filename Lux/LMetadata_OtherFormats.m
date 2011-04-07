//
//  LMetadata_OtherFormats.m
//  Lux
//
//  Created by Adrien Bertrand on 05/04/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import "LMetadata_OtherFormats.h"
#import "LDefinitions.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation LMetadata_OtherFormats


- (NSArray *) supportedMetadataExtensions
{
	return [NSArray arrayWithObjects:@"aac", @"m4a", @"mp3", @"wav", @"m4p", @"avi", @"mp4", @"flv", nil];
}

- (NSDictionary *) metadataForURL:(NSURL *)fileURL
{	
	static AudioFileID fileID = nil;
	static OSStatus err = noErr;
	
	err = AudioFileOpenURL((CFURLRef) fileURL, kAudioFileReadPermission, 0, &fileID);
	if ( err != noErr )
	{
		NSLog(@"AudioFileOpenURL failed - %@",fileURL);
		return nil;
	}
		
    MDItemRef item = MDItemCreateWithURL(NULL,(CFURLRef)fileURL);
    CFArrayRef metadataDict = MDItemCopyAttributeNames(item);
    
	NSDictionary * mdDictTMP = NSMakeCollectable(MDItemCopyAttributes(item, metadataDict));
    
    NSMutableDictionary *mdDict = [[[NSMutableDictionary alloc] init] autorelease];
        
	NSString * genre = [mdDictTMP objectForKey:(NSString *)kMDItemMusicalGenre];
	NSArray * artists = [mdDictTMP objectForKey:(NSString *)kMDItemAuthors];
	NSString * composer = [mdDictTMP objectForKey:(NSString *)kMDItemComposer];
	NSString * album = [mdDictTMP objectForKey:(NSString *)kMDItemAlbum];
	NSNumber * time = [mdDictTMP objectForKey:(NSNumber *)kMDItemDurationSeconds];
    NSNumber * width = [mdDictTMP objectForKey:(NSNumber *)kMDItemPixelWidth];
	NSNumber * height = [mdDictTMP objectForKey:(NSNumber *)kMDItemPixelHeight];
	NSNumber * year = [mdDictTMP objectForKey:(NSNumber *)kMDItemRecordingYear];
	    
	if (genre)
	{
		[mdDict setObject:genre forKey:kGENRE];
	}
	
	if (artists)
	{
		[mdDict setObject:[artists objectAtIndex:0] forKey:kARTIST];
	}
	
	if (composer)
	{
		[mdDict setObject:composer forKey:kCOMPOSER];
	}
	
	if (album)
	{
		[mdDict setObject:album forKey:kALBUM];
	}
	
	if (time)
	{
		time = [NSNumber numberWithInt:[time intValue] * 1000]; // converting seconds to miliseconds
		[mdDict setObject:time forKey:kTIME];
	}
	
	if (year)
	{
		[mdDict setObject:year forKey:kYEAR];
	}
	
    if (height)
	{
		[mdDict setObject:height forKey:kHEIGHT];
	}
	
    if (width)
	{
		[mdDict setObject:width forKey:kWIDTH];
	}
	
	return mdDict;
}


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

- (BOOL) requiresMainThread
{
	return YES;
}

@end
