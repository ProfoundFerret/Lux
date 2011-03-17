//
//  LPlayerGui.m
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import "LPlayerGui.h"
#import "LPlayerController.h"

#define controller [LPlayerController sharedInstance]

@implementation LPlayerGui

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

- (void) awakeFromNib
{
	[playPauseButton setTarget:controller];
	[playPauseButton setAction:@selector(playPauseOrStartPlaying)];
	
	[previousButton setTarget:controller];
	[previousButton setAction:@selector(playPreviousFile)];
	
	[nextButton setTarget:controller];
	[nextButton setAction:@selector(playNextFile)];
}

@end
