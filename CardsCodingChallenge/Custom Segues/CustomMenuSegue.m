//
//  CustomMenuSegue.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/14/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import "CustomMenuSegue.h"

@implementation CustomMenuSegue

- (void)perform
{
    [[self destinationViewController] setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [[self sourceViewController] presentViewController:[self destinationViewController]
                                              animated:YES
                                            completion:nil];
}

@end