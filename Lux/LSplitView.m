//
//  LSplitView.m
//  Lux
//
//  Created by Adrien Bertrand on 04/04/11.
//  Copyright 2011 Adrien Bertrand. All rights reserved.
//

#import "LSplitView.h"

@implementation LSplitView

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

- (CGFloat) dividerThickness
{
	return 5.0;
}
@end
