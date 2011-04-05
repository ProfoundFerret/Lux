//
//  LuxGui.h
//  Lux
//
//  Created by Kyle Carson on 4/4/11.
//  Copyright 2011 ProfoundFerret. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSplitView.h"
#import "LGuiObject.h"

@interface LuxGui : LGuiObject <NSSplitViewDelegate> {
    IBOutlet LSplitView * splitView;
}

@end
