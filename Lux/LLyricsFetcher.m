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

- (void) fetchLyricsForFile : (LFile *) file;
{
	[self fetchLyricsForFiles:[NSArray arrayWithObject:file]];
}

- (void) fetchLyricsForFiles: (NSArray *) files
{
	@synchronized(self)
	{
		for (LFile * file in files)
		{
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
				lyrics = nil;
				if (![parser parse])
					continue;
				
				NSLog(@"lyrics found : %@",lyrics);
				continue;
			}
			
			NSLog(@"Request to chartlyrics.com gets error code : %ld", [response statusCode]);
			
			[[file attributes] setObject:lyrics forKey:kLYRICS];
			
			continue;
		}
	}
	
	[[LInputOutputController sharedInstance] setNeedsSaved:YES];
}

- (void) fetchLyricsForFilesFromMenuItem: (NSMenuItem *) menuItem
{
	[self fetchLyricsForFiles:[menuItem representedObject]];
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
    [menuItem setAction:@selector(fetchLyricsForSong)];
	[menuItem setRepresentedObject:files];
        
    NSArray * array = [NSArray arrayWithObject:menuItem];
    
    return array;
}

@end
