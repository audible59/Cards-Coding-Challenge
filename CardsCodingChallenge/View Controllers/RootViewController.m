//
//  ViewController.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/12/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "RootViewController.h"
#import "ScrollViewContainer.h"
#import "CustomMenuUnwindSegue.h"

@interface RootViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

#pragma mark -
#pragma mark PRIVATE Primitive Type Properties
#pragma mark -

@property (assign) BOOL isScrollViewFullyVisible;
@property (nonatomic, assign) CGFloat lastContentOffset;

#pragma mark -
#pragma mark PRIVATE UILabel Property
#pragma mark -

@property (strong, nonatomic) IBOutlet UILabel *helloLabel;

#pragma mark -
#pragma mark PRIVATE UIView Property
#pragma mark -

@property (strong, nonatomic) UIView *currentPageView;

#pragma mark -
#pragma mark PRIVATE ScrollViewContainer Property
#pragma mark -

@property (strong, nonatomic) IBOutlet ScrollViewContainer *scrollViewContainer;

#pragma mark -
#pragma mark PRIVATE UIScrollView Properties
#pragma mark -

@property (strong, nonatomic) IBOutlet UIScrollView *horizontalScrollView;

#pragma mark -
#pragma mark PRIVATE NSMutableArray Property
#pragma mark -

@property (strong, nonatomic) NSMutableArray *accumulator;
@property (strong, nonatomic) NSMutableArray *pageViewsMutableArray;

#pragma mark -
#pragma mark PRIVATE UIDynamicAnimator Property
#pragma mark -

@property (strong, nonatomic) UIDynamicAnimator *animator;

#pragma mark -
#pragma mark PRIVATE UIDynamicAnimator Property
#pragma mark -

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

#pragma mark -
#pragma mark PRIVATE Helper Methods
#pragma mark -

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;

@end

@implementation RootViewController

#pragma mark -
#pragma mark View Life Cycle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self helloLabel] setAlpha:0.0f];
    
    // Set the BOOL to YES because we want to show the entire UIScrollView
    [self setIsScrollViewFullyVisible:YES];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self horizontalScrollView]];
    
    // Initialize the NSMutableArrays
    self.pageViewsMutableArray = [[NSMutableArray alloc] initWithCapacity:MAX_NUMBER_OF_IMAGES];
    
    for(NSInteger i = 0; i < MAX_NUMBER_OF_IMAGES; ++i)
    {
        [[self pageViewsMutableArray] addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set the content size of the UIScrollView
    CGSize pagesHorizontalScrollViewSize = self.horizontalScrollView.frame.size;
    
    [[self horizontalScrollView] setContentSize:CGSizeMake(pagesHorizontalScrollViewSize.width * MAX_NUMBER_OF_IMAGES,
                                                           pagesHorizontalScrollViewSize.height)];
    
    [[self horizontalScrollView] setDirectionalLockEnabled:YES];
    
    // TODO: Add UIPanGestureRecognizer to the UIScrollView to pan the UIScrollView up and down
//    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
//                                                              action:@selector(didPanScrollView:)];
//    
//    [[self panGesture] setDelegate:self];
//    
//    [[self horizontalScrollView]  addGestureRecognizer:[self panGesture]];
//    [[[self horizontalScrollView] panGestureRecognizer] setEnabled:NO];
    
    /*
     *
     * The UISwipeGestureRecognizer is a temporary solution for getting the UIScrollView to move up and down.
     * The goal is to use a UIPanGestureRecognizer so that the user can pan the UIScrollView up and down smoothly.
     *
     */
    // Instantiate and add a UISwipeGestureRecognizer for both up and down directions
    UISwipeGestureRecognizer *swipeGestureRecognizer;
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didSwipeScrollView:)];
    
    [swipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [[self horizontalScrollView] addGestureRecognizer:swipeGestureRecognizer];
    
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didSwipeScrollView:)];
    
    [swipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    // Add the UISwipeGestureRecognizer to the UIScrollView
    [[self horizontalScrollView] addGestureRecognizer:swipeGestureRecognizer];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    
    // Adjust the alpha for all visible pages
	[[self pageViewsMutableArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
		[self setAlphaForPage:obj];
//        [self setTransformForPage:obj];
        
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIScrollView Delegate Methods
#pragma mark -

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == [self horizontalScrollView])
    {
        // Load the pages that are on the screen
        [self loadVisiblePages];
        
        // Adjust the alpha for all visible pages
        [[self pageViewsMutableArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            
            [self setAlphaForPage:obj];
//        [self setTransformForPage:obj];
            
        }];
    }
}

#pragma mark -
#pragma mark UIGestureRecognizer Delegate Methods
#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if([gestureRecognizer      isEqual:[self panGesture]] &&
       [otherGestureRecognizer isEqual:[[self horizontalScrollView] panGestureRecognizer]])
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:[self panGesture]])
    {
        if([gestureRecognizer numberOfTouches] > 0)
        {
            CGPoint translation = [[self panGesture] velocityInView:[self horizontalScrollView]];
            
            return fabs(translation.y) > fabs(translation.x);
        }
        else
        {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark -
#pragma mark IBAction Methods
#pragma mark -

- (IBAction)returnedFromSegue:(UIStoryboardSegue *)segue
{
    NSLog(@"Returned from CustomMenuViewController");
}

#pragma mark -
#pragma mark SELECTOR Methods
#pragma mark -

// Temporary solution that will animate the UIScrollView up and down
- (void)didSwipeScrollView:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    switch([swipeGestureRecognizer direction])
    {
        case UISwipeGestureRecognizerDirectionUp:
            
            NSLog(@"User swiped up");
            
            [self animateScrollViewForFullView:YES];
            
            break;
            
        case UISwipeGestureRecognizerDirectionDown:
            
            NSLog(@"User swiped down");
            
            [self animateScrollViewForFullView:NO];
            
            break;
            
        case UISwipeGestureRecognizerDirectionLeft:
            
            // We only want to handle the up and down Swipe Getures
            
            break;
            
        case UISwipeGestureRecognizerDirectionRight:
            
            // We only want to handle the up and down Swipe Getures
            
            break;
            
        default:
            
            break;
    }
}

// Primary solution that will pan the UIScrollView up and down
- (void)didPanScrollView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if([panGestureRecognizer numberOfTouches] > 0)
    {
        CGPoint translation = [[self panGesture] velocityInView:[self horizontalScrollView]];
        
        // If we are swiping up or down
        if(fabs(translation.y) > fabs(translation.x))
        {
            CGPoint translation = [panGestureRecognizer translationInView:[self view]];
            
            // If we have reached the MAX height for the UIPanGestureRecognizer
            if((panGestureRecognizer.view.center.y + translation.y) == self.view.bounds.size.height)
            {
                // TODO: Add Bounce animation to the Horizontal UIScrollView
            }
            else if((panGestureRecognizer.view.center.y + translation.y) == self.view.bounds.size.height)
            {
                [[panGestureRecognizer view] setCenter:CGPointMake(panGestureRecognizer.view.center.x,
                                                                   MAX(panGestureRecognizer.view.center.y + translation.y, self.view.bounds.size.height))];
                
                [panGestureRecognizer setTranslation:CGPointMake(0, 0)
                                              inView:[self view]];
                
                if([panGestureRecognizer state] == UIGestureRecognizerStateEnded)
                {
                    CGPoint velocity = [panGestureRecognizer velocityInView:[self view]];
                    
                    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
                    
                    CGFloat slideMult = magnitude / 200;
                    
                    float slideFactor = 0.1 * slideMult; // Increase for more of a slide
                    
                    CGPoint finalPoint = CGPointMake(panGestureRecognizer.view.center.x,
                                                     panGestureRecognizer.view.center.y + (velocity.y * slideFactor));
                    
                    finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
                    finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
                    
                    [UIView animateWithDuration:slideFactor * 2
                                          delay:0.0f
                                        options:UIViewAnimationOptionCurveEaseOut
                                     animations:^{
                                         
                                         [[panGestureRecognizer view] setCenter:finalPoint];
                                         
                                     }
                                     completion:nil];
                    
                }
            }
        }
    }
}

#pragma mark -
#pragma mark - Segue Navigation
#pragma mark -

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController
                                      fromViewController:(UIViewController *)fromViewController
                                              identifier:(NSString *)identifier
{
    // Ensure that we are receiving the correct UIStoryboardSegue identifier
    if([identifier isEqualToString:kUnwindCustomMenuViewControllerSegue])
    {
        CustomMenuUnwindSegue *segue = [[CustomMenuUnwindSegue alloc] initWithIdentifier:identifier
                                                                                  source:fromViewController
                                                                             destination:toViewController];
        
        return segue;
    }
    
    // return the default unwind segue otherwise
    return [super segueForUnwindingToViewController:toViewController
                                 fromViewController:fromViewController
                                         identifier:identifier];
}

#pragma mark -
#pragma mark UI Helper Methods
#pragma mark -

- (void)loadVisiblePages
{
    // Determine which page is currently visible
    CGFloat pageWidth = self.horizontalScrollView.frame.size.width;
    
    NSInteger page = (NSInteger)floor((self.horizontalScrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage  = page + 1;
    
    // Purge anything before the first page
    for(NSInteger i = 0; i < firstPage; i++)
    {
        [self purgePage:i];
    }
    
    // Load the visible pages
    for(NSInteger i = firstPage; i <= lastPage; i++)
    {
        [self loadPage:i];
    }
    
    // Purge anything after the last page
    for(NSInteger i = lastPage + 1; i < MAX_NUMBER_OF_IMAGES; i++)
    {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page
{
    // If the current page number is less than 0 OR greater than 100 we exit the function
    if(page < 0 || page >= MAX_NUMBER_OF_IMAGES)
    {
        return;
    }
    
    UIView *pageView = [[self pageViewsMutableArray] objectAtIndex:page];
    
    // Check if the current UIView exists
    if((NSNull *)pageView == [NSNull null])
    {
        // Setup the frame to be used for the UIImageView
        CGRect frame = self.horizontalScrollView.bounds;
        
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame          = CGRectInset(frame, 10.0f, 0.0f);
        
        // Instantiate and setup the UIImageView
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallCardBG.png"]];
        
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        [tempImageView setFrame:frame];
        
        // Instantiate and setup the UILabel
        UILabel *tempLabel;
        
        if(page < 9)
        {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempImageView.bounds.origin.x + 125,
                                                                  tempImageView.bounds.origin.y + 55,
                                                                  25,
                                                                  40)];
        }
        else if(page > 9 || page < 100)
        {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempImageView.bounds.origin.x + 110,
                                                                  tempImageView.bounds.origin.y + 55,
                                                                  25,
                                                                  40)];
        }
        
        [tempLabel setTextColor:[UIColor darkGrayColor]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        
        [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue"
                                           size:40]];
        
        [tempLabel setText:[NSString stringWithFormat:@"%li", (long)page]];
        
        [tempLabel sizeToFit];
        
        
        // Add the UILabel to the UIImageView
        [tempImageView addSubview:tempLabel];
        
        // Add the UIImageView to the UIScrollView
        [[self horizontalScrollView] addSubview:tempImageView];
        
        // Add the UIImageView to the NSMutableArray for later use
        [[self pageViewsMutableArray] replaceObjectAtIndex:page
                                                withObject:tempImageView];
    }
}

- (void)purgePage:(NSInteger)page
{
    // If the current page number is less than 0 OR greater than 100 we exit the function
    if (page < 0 || page >= MAX_NUMBER_OF_IMAGES)
    {
        return;
    }
    
    UIView *pageView = [[self pageViewsMutableArray] objectAtIndex:page];
    
    // Check if the current UIView exists
    if((NSNull *)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        
        // Remove the UIView from the NSMutableArray
        [[self pageViewsMutableArray] replaceObjectAtIndex:page
                                    withObject:[NSNull null]];
    }
}

- (void)setAlphaForPage:(UIView *)page
{
    // Check if the current UIView exists
    if((NSNull *)page != [NSNull null])
    {
        CGFloat offset = self.horizontalScrollView.contentOffset.x;
        CGFloat origin = page.frame.origin.x;
        CGFloat delta = fabs(origin - offset);
        CGFloat alpha = 0.0;
        
        if(delta < page.frame.size.width)
        {
            alpha = 1 - delta / page.frame.size.width * 0.7;
        }
        else
        {
            alpha = 0.3;
        }
        
        [page setAlpha:alpha];
    }
}

// TODO: Add transform to the UIImageView that is centered within the UIScrollView
- (void)setTransformForPage:(UIView *)page
{
    // Check if the current UIView exists
    if((NSNull *)page != [NSNull null])
    {
        float position = page.center.x - self.horizontalScrollView.contentOffset.x;
        float offset   = 2.0 - (fabs(self.horizontalScrollView.center.x - position) * 1.0) / self.horizontalScrollView.center.x;
        
        NSLog(@"OFFSET - %f", offset);
        
        page.transform = CGAffineTransformIdentity;
        page.transform = CGAffineTransformScale(page.transform, offset, offset);
    }
}

- (void)animateScrollViewForFullView:(BOOL)shouldDisplayFullView
{
    // If the user swiped up we show the full UIScrollView
    if(shouldDisplayFullView == YES)
    {
        // Ensure that the UIScrollView is not fully visible
        if([self isScrollViewFullyVisible] == NO)
        {
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.9f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                             
                                 self.horizontalScrollView.frame = CGRectMake(self.horizontalScrollView.frame.origin.x,
                                                                    self.horizontalScrollView.frame.origin.y - 100,
                                                                    self.horizontalScrollView.frame.size.width,
                                                                    self.horizontalScrollView.frame.size.height);
                                 
                                 // Hide the UILabel
                                 [[self helloLabel] setAlpha:0.0f];
                             
                             }
                             completion:^(BOOL finished){
                             
                                 [self setIsScrollViewFullyVisible:YES];
                             
                             }];
        }
    }
    // Else the user swiped down so we partially hide the UIScrollView
    else
    {
        // Ensure that the UIScrollView is fully visible
        if([self isScrollViewFullyVisible] == YES)
        {
            [UIView animateWithDuration:0.4f
                                  delay:0.0f
                 usingSpringWithDamping:0.6f
                  initialSpringVelocity:0.9f
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                                 
                                 self.horizontalScrollView.frame = CGRectMake(self.horizontalScrollView.frame.origin.x,
                                                                    self.horizontalScrollView.frame.origin.y + 100,
                                                                    self.horizontalScrollView.frame.size.width,
                                                                    self.horizontalScrollView.frame.size.height);
                                 
                                 // Show the UILabel
                                 [[self helloLabel] setAlpha:1.0f];
                                 
                             }
                             completion:^(BOOL finished){
                                 
                                 [self setIsScrollViewFullyVisible:NO];
                                 
                             }];
        }
    }
    
//    [[self animator] removeAllBehaviors];
//    
//    CGFloat boundaryPointY    = (shouldDisplayFullView) ? -10.0 : self.scrollViewContainer.frame.size.height;
//    CGFloat gravityDirectionY = (shouldDisplayFullView) ? -0.1 : 0.1;
//    
//    // Create and add the UIGravityBehaviour to the UIDynamicAnimator object
//    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[[self scrollView]]];
//    
//    [gravityBehavior setGravityDirection:CGVectorMake(0.0, gravityDirectionY)];
//    
//    [[self animator] addBehavior:gravityBehavior];
//
//    // Create and add the UICollisionBehavior to the UIDynamicAnimator object
//    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[[self scrollView]]];
//    
//    [collisionBehavior addBoundaryWithIdentifier:@"scrollViewBoundary"
//                                       fromPoint:CGPointMake(0.0, boundaryPointY)
//                                         toPoint:CGPointMake(self.scrollViewContainer.frame.origin.x, boundaryPointY)];
//    
//    [self.animator addBehavior:collisionBehavior];
//    
//    // Create and add the UIDynamicItemBehavior to the UIDynamicAnimator object
//    UIDynamicItemBehavior *menuViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[[self scrollView]]];
//    
//    [menuViewBehavior setElasticity:0.2];
//    
//    [self.animator addBehavior:menuViewBehavior];
}

@end