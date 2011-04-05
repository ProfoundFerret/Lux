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
	return [NSArray arrayWithObjects:@"aac", @"m4a", @"mp3", @"wav", @"wma", @"m4p", @"mov", @"avi", @"wmv", @"mp4", @"flv", @"m4v", nil];
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
    
	NSMutableDictionary * mdDictTMP = (NSMutableDictionary *) [NSMakeCollectable(MDItemCopyAttributes(item, metadataDict)) autorelease];
    
    NSMutableDictionary *mdDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemMusicalGenre] forKey:kGENRE];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemTitle] forKey:kTITLE];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemAuthors] forKey:kARTIST];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemComposer] forKey:kCOMPOSER];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemAlbum] forKey:kALBUM];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemDurationSeconds] forKey:kTIME];
    [mdDict setObject:[mdDictTMP objectForKey:(NSString *)kMDItemRecordingYear] forKey:kYEAR];
    
	NSLog(@"> %@", mdDict);
	
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

@end
