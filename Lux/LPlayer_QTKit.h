//
//  LPlayer_QTKit.h
//  Lux
//
//  Created by Kyle Carson on 3/11/11.
//  Copyright 2011 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LExtension.h"
#import <QTKit/QTKit.h>

@interface LPlayer_QTKit : LExtension <LPlayerDelegate> {
	QTMovie * player;
	BOOL isPlaying;
}
- (void) fileEnded;
@end
