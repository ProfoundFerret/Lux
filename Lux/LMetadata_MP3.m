//
//  LMetadata_MP3.m
//  Lux
//
//  Created by Kyle Carson on 3/16/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LMetadata_MP3.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation LMetadata_MP3

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

- (NSArray *) supportedMetadataExtensions
{
	return [NSArray arrayWithObject:@"mp3"];
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
	UInt32 id3DataSize = 0;
	
	err = AudioFileGetPropertyInfo(fileID, kAudioFilePropertyID3Tag, &id3DataSize, NULL);
	if (err != noErr)
	{
		NSLog(@"AudioFileGetPropertyInfo failed for ID3 tag - %@",fileURL);
		return nil;
	}
	char * rawID3Tag = (char *) malloc(id3DataSize);
	
	err = AudioFileGetProperty(fileID, kAudioFilePropertyID3Tag, &id3DataSize, rawID3Tag);
	if (err != noErr)
	{
		free(rawID3Tag);
		NSLog(@"AudioFileGetProperty failed for ID3 tag - %@",fileURL);
		return nil;
	}
	UInt32 id3TagSize = 0;
    UInt32 id3TagSizeLength = 0;
    err = AudioFormatGetProperty( kAudioFormatProperty_ID3TagSize, 
                                 id3DataSize, 
                                 rawID3Tag, 
                                 &id3TagSizeLength, 
                                 &id3TagSize
                                 );
	free(rawID3Tag);
    if( err != noErr ) {
        NSLog( @"AudioFormatGetProperty failed for ID3 tag size - %@",fileURL);
		
        switch( err ) {
            case kAudioFormatUnspecifiedError:
                NSLog( @"err: audio format unspecified error" ); 
                break;
            case kAudioFormatUnsupportedPropertyError:
                NSLog( @"err: audio format unsupported property error" ); 
                break;
            case kAudioFormatBadPropertySizeError:
                NSLog( @"err: audio format bad property size error" ); 
                break;
            case kAudioFormatBadSpecifierSizeError:
                NSLog( @"err: audio format bad specifier size error" ); 
                break;
            case kAudioFormatUnsupportedDataFormatError:
                NSLog( @"err: audio format unsupported data format error" ); 
                break;
            case kAudioFormatUnknownFormatError:
                NSLog( @"err: audio format unknown format error" ); 
                break;
            default:
                NSLog( @"err: some other audio format error" ); 
                break;
        }		
		return nil;
    }
	
	CFDictionaryRef piDict = nil;
    UInt32 piDataSize   = sizeof( piDict );
	
    err = AudioFileGetProperty( fileID, kAudioFilePropertyInfoDictionary, &piDataSize, &piDict );
    if( err != noErr ) {
        NSLog( @"AudioFileGetProperty failed for property info dictionary - %@",fileURL);
		return nil;
    }
	NSMutableDictionary * piDict2 = (NSMutableDictionary *) piDict;
	
	NSString * numberAsString = [piDict2 objectForKey:@"approximate duration in seconds"];
	static NSNumberFormatter * formatter;
	if (! formatter)
	{
		formatter = [[[NSNumberFormatter alloc] init] autorelease];
		[formatter setNumberStyle:NSNumberFormatterDecimalStyle];
	}
	static NSNumber * number;
	number = [formatter numberFromString:numberAsString];
	number = [NSNumber numberWithInt:([number intValue] * 1000)];
	
	[piDict2 removeObjectForKey:@"approximate duration in seconds"];
	
	[piDict2 setObject:number forKey:kTIME];
	
	static int year;
	year = [[piDict2 objectForKey:kYEAR] intValue];
	[piDict2 setObject:[NSNumber numberWithInt:year] forKey:kYEAR];
	
	return piDict2;
}

@end
