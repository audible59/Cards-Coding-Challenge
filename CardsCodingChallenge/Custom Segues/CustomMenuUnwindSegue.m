//
//  CustomMenuUnwindSegue.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/14/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import "CustomMenuUnwindSegue.h"

@implementation CustomMenuUnwindSegue

- (void)perform
{
    // Ensure that the Source UIViewController is not being dismissed while we call dismissViewControllerAnimated:completion:
    if(![[self sourceViewController] isBeingDismissed])
    {
        // Unwind the current UIStoryboardSegue by simply dismissing the Destination UIViewController
        [[self sourceViewController] dismissViewControllerAnimated:YES
                                                        completion:^{}];
    }
}

@end