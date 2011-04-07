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

- (NSString *) fetchLyricsForSong
{
    LFile * theFile = [[LFileController sharedInstance] activeFile];

    NSString * title = [[theFile attributes] objectForKey:kTITLE];
	NSMutableString * artist = [[theFile attributes] objectForKey:kARTIST];
	
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
		return nil;
	}
	
	if ([response statusCode] >= 200 && [response statusCode] < 300) {
		NSXMLParser *parser = [[[NSXMLParser alloc] initWithData:data] autorelease];
		[parser setDelegate:self];
		lyrics = nil;
		if (![parser parse])
			return nil;
		
        NSLog(@"lyrics found : %@",lyrics);
		return lyrics;
	}
	
	NSLog(@"Request to chartlyrics.com gets error code : %ld", [response statusCode]);
    
    [[theFile attributes] setObject:lyrics forKey:kLYRICS];
    
	return nil;
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
    [menuItem setTitle:@"Find Lyrics"];
    [menuItem setEnabled:YES];
    [menuItem setTarget:self];
    [menuItem setAction:@selector(fetchLyricsForSong)];
        
    NSArray * array = [NSArray arrayWithObject:menuItem];
    
    return array;
}

@end
