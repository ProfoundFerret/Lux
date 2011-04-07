//
//  LLyricsFetcher.h
//  Lux
//
//  Created by Adrien Bertrand on 07/04/11.
//  Copyright 2011 Adrien Bertrand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LExtension.h"
#import "Lux.h"

@interface LLyricsFetcher : LExtension <NSXMLParserDelegate> {

    NSString *lyrics;
}    

- (NSString *) fetchLyricsForSong;

@end
