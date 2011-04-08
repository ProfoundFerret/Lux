//
//  LLyricsFetcher.m
//  Lux
//
//  Created by Adrien Bertrand on 07/04/11.
//  Copyright 2011 Adrien Bertrand. All rights reserved.
//

#import "LLyricsFetcher.h"
#import "LDefinitions.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Lux.h"

@implementation LLyricsFetcher

- (id)init
{
    self = [super init];
    if (self) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchLyricsForSong) name:kPLAY_NOTIFICATION object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void) fetchLyricsForFile : (LFile *) file;
{
	[self fetchLyricsForFiles:[NSArray arrayWithObject:file] forced:NO];
}

- (void) fetchLyricsForFiles: (NSArray *)files forced:(BOOL)forced
{
    
    @synchronized(self)
	{
		for (LFile * file in files)
		{
            if ([file fileType] == LFileTypeAudio) {
                
                if (forced || ! [[file attributes] objectForKey:kLYRICS]) {
                                        
                    NSString * title = [[file attributes] objectForKey:kTITLE];
                    NSMutableString * artist = [[file attributes] objectForKey:kARTIST];
                    
                    NSMutableString * artistText;
                    if ([artist length])
                    {
                        artistText = [NSString stringWithFormat:@"%@\n", artist];
                    } else {
                        artistText = [NSMutableString stringWithString:@""];
                    }
                    
                    NSString *escapedArtist = [artistText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    NSString *escapedName   = [title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    
                    NSString *url = [NSString 
                                     stringWithFormat:@"http://api.chartlyrics.com/apiv1.asmx/SearchLyricDirect?artist=%@&song=%@",
                                     escapedArtist,
                                     escapedName];
                    
                    NSMutableURLRequest *request = [[NSMutableURLRequest new] autorelease];
                    [request setURL:[NSURL URLWithString:url]];
                    [request setHTTPMethod:@"GET"];
                    
                    NSHTTPURLResponse *response = nil;  
                    NSError *error = [NSError new];
                    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];  
                    if (data == nil) {
                        NSLog(@"Request to chartlyrics.com failed with error: %@", [error localizedDescription]);
                        continue;
                    }
                    
                    if ([response statusCode] >= 200 && [response statusCode] < 300) {
                        NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
                        [parser setDelegate:self];
                        
                        if (![parser parse])
                            continue;
                        
                        [[file attributes] setObject:lyrics forKey:kLYRICS];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kLYRICS_FOUND object:file];
                        
                        continue;
                    }
                    
                    NSLog(@"Something went wrong ... Maybe : Request to chartlyrics.com gets error code : %ld", [response statusCode]);
                                        
                    continue;
                }
            }
        }
    }
	[[LInputOutputController sharedInstance] setNeedsSaved:YES];
}

- (void) fetchLyricsForFilesFromMenuItem: (NSMenuItem *) menuItem
{
	[self fetchLyricsForFiles:[menuItem representedObject] forced:YES];
}

- (void) fetchLyricsForSong
{
	LFile * activeFile = [[LFileController sharedInstance] activeFile];
	[self fetchLyricsForFile:activeFile];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"Lyric"]) {
		lyrics = [NSString string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	lyrics = [lyrics stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
}

- (NSArray *) menuItemsForFiles:(NSArray *)files
{
    NSMenuItem * menuItem = [[NSMenuItem alloc] init];
    [menuItem setTitle:@"Update Lyrics"];
    [menuItem setEnabled:YES];
    [menuItem setTarget:self];
    [menuItem setAction:@selector(fetchLyricsForFilesFromMenuItem:)];
	[menuItem setRepresentedObject:files];
        
    NSArray * array = [NSArray arrayWithObject:menuItem];
    
    return array;
}

@end
