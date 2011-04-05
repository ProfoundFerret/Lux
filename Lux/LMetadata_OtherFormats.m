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
	return [NSArray arrayWithObjects:@"aac", @"m4a", nil];
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
	
	NSLog(@"%@",mdDictTMP);
    
    NSMutableDictionary *mdDict = [[[NSMutableDictionary alloc] init] autorelease];
    
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemMusicalGenre] forKey:kGENRE];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemTitle] forKey:kTITLE];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemAuthors] forKey:kARTIST];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemComposer] forKey:kCOMPOSER];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemAlbum] forKey:kALBUM];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemDurationSeconds] forKey:kTIME];
    [mdDict setObject:[mdDictTMP objectForKey:kMDItemRecordingYear] forKey:kYEAR];
    
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
