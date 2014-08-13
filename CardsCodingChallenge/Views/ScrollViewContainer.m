//
//  ScrollViewContainer.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/12/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import "ScrollViewContainer.h"

@interface ScrollViewContainer ()

#pragma mark -
#pragma mark PRIVATE Helper Method
#pragma mark -

- (UIView *)hitTest:(CGPoint)point
          withEvent:(UIEvent *)event;

@end

@implementation ScrollViewContainer

#pragma mark -
#pragma mark Helper Method
#pragma mark -

- (UIView *)hitTest:(CGPoint)point
         withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point
                        withEvent:event];
    
    if(view == self)
    {
        return [self scrollView];
    }
    
    return view;
}

@end