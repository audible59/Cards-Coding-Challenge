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

@interface RootViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

#pragma mark -
#pragma mark PRIVATE Primitive Type Properties
#pragma mark -

@property (nonatomic, assign) CGFloat lastContentOffset;

#pragma mark -
#pragma mark PRIVATE NSMutableArray Property
#pragma mark -

@property (strong, nonatomic) NSMutableArray *pageViewsMutableArray;
@property (strong, nonatomic) NSMutableArray *visiblePageViewsMutableArray;

#pragma mark -
#pragma mark PRIVATE UIDynamicAnimator Property
#pragma mark -

@property (strong, nonatomic) UIDynamicAnimator *animator;

#pragma mark -
#pragma mark PRIVATE UIView Property
#pragma mark -

@property (strong, nonatomic) UIView *currentPageView;

#pragma mark -
#pragma mark PRIVATE ScrollViewContainer Property
#pragma mark -

@property (strong, nonatomic) IBOutlet ScrollViewContainer *scrollViewContainer;

#pragma mark -
#pragma mark PRIVATE UIScrollView Property
#pragma mark -

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

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
    
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x,
//                                                                     self.scrollView.frame.origin.y,
//                                                                     self.scrollView.frame.size.width,
//                                                                     self.scrollView.frame.size.height)];
//    
//    [[self scrollView] setDelegate:self];
//    [[self scrollView] setPagingEnabled:YES];
//    [[self scrollView] setBackgroundColor:[UIColor lightGrayColor]];
//    [[self scrollView] setShowsVerticalScrollIndicator:NO];
//    [[self scrollView] setShowsHorizontalScrollIndicator:NO];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:[self scrollView]];
    
    // Initialize the NSMutableArrays
    self.pageViewsMutableArray        = [[NSMutableArray alloc] initWithCapacity:MAX_NUMBER_OF_IMAGES];
    self.visiblePageViewsMutableArray = [[NSMutableArray alloc] initWithCapacity:3];
    
    for(NSInteger i = 0; i < MAX_NUMBER_OF_IMAGES; ++i)
    {
        [[self pageViewsMutableArray] addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    
    [[self scrollView] setContentSize:CGSizeMake(pagesScrollViewSize.width * MAX_NUMBER_OF_IMAGES,
                                                 pagesScrollViewSize.height)];
    
    UISwipeGestureRecognizer *gestureRecognizer;
    
    gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didSwipeScrollView:)];
    
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [[self scrollView] addGestureRecognizer:gestureRecognizer];
    
    gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(didSwipeScrollView:)];
    
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    
    [[self scrollView] addGestureRecognizer:gestureRecognizer];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
    
    for(int i = 0; i < 3; i++)
    {
        [[self visiblePageViewsMutableArray] addObject:[[self pageViewsMutableArray] objectAtIndex:i]];
    }
    
    // Adjust the alpha for all visible pages
	[[self pageViewsMutableArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
		[self setAlphaForPage:obj];
        
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
    if([self lastContentOffset] > scrollView.contentOffset.x)
    {
        // The user is scrolling right
        
    }
    else if([self lastContentOffset] < scrollView.contentOffset.x)
    {
        // The user is scrolling left
        
    }
    
    self.lastContentOffset = scrollView.contentOffset.x;
    
    // Load the pages that are now on screen
    [self loadVisiblePages];
    
    // Adjust the alpha for all visible pages
	[[self pageViewsMutableArray] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        
		[self setAlphaForPage:obj];
        
	}];
}

#pragma mark -
#pragma mark SELECTOR Methods
#pragma mark -

- (void)didSwipeScrollView:(UISwipeGestureRecognizer *)gesture
{
    switch([gesture direction])
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

#pragma mark -
#pragma mark UI Helper Methods
#pragma mark -

- (void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage  = page + 1;
    
    // Purge anything before the first page
    for(NSInteger i = 0; i < firstPage; i++)
    {
        [self purgePage:i];
    }
    
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
        CGRect frame = self.scrollView.bounds;
        
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame          = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallCardBG.png"]];
        
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        [tempImageView setFrame:frame];
        
        UILabel *tempLabel;
        
        if(page < 9)
        {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempImageView.bounds.origin.x + 125,
                                                                  tempImageView.bounds.origin.y + 15,
                                                                  25,
                                                                  40)];
        }
        else if(page > 9 || page < 100)
        {
            tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempImageView.bounds.origin.x + 110,
                                                                  tempImageView.bounds.origin.y + 15,
                                                                  25,
                                                                  40)];
        }
        
        [tempLabel setTextColor:[UIColor darkGrayColor]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        
        [tempLabel setFont:[UIFont fontWithName:@"HelveticaNeue"
                                           size:40]];
        
        [tempLabel setText:[NSString stringWithFormat:@"%li", (long)page]];
        
        [tempLabel sizeToFit];
        
        [tempImageView addSubview:tempLabel];
        
        CGFloat pageWidth = self.scrollView.frame.size.width;
        
        NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
        
        // Work out which pages you want to load
        NSInteger firstPage = page - 1;
        NSInteger lastPage  = page + 1;
        
        if(page)
        {
            
        }
        
        tempImageView.transform = CGAffineTransformMakeScale(0.6, 0.6);
        
        // Add the UIImageView to the UIScrollView
        [[self scrollView] addSubview:tempImageView];
        
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
        CGFloat offset = self.scrollView.contentOffset.x;
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

- (void)animateScrollViewForFullView:(BOOL)shouldDisplayFullView
{
    [[self animator] removeAllBehaviors];
    
    CGFloat boundaryPointY    = (shouldDisplayFullView) ? -10.0 : self.scrollViewContainer.frame.size.height;
    CGFloat gravityDirectionY = (shouldDisplayFullView) ? -0.1 : 0.1;
    
    // Create and add the UIGravityBehaviour to the UIDynamicAnimator object
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[[self scrollView]]];
    
    [gravityBehavior setGravityDirection:CGVectorMake(0.0, gravityDirectionY)];
    
    [[self animator] addBehavior:gravityBehavior];
    
    // Create and add the UICollisionBehavior to the UIDynamicAnimator object
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[[self scrollView]]];
    
    [collisionBehavior addBoundaryWithIdentifier:@"scrollViewBoundary"
                                       fromPoint:CGPointMake(0.0, boundaryPointY)
                                         toPoint:CGPointMake(self.scrollViewContainer.frame.origin.x, boundaryPointY)];
    
    [self.animator addBehavior:collisionBehavior];
    
    // Create and add the UIDynamicItemBehavior to the UIDynamicAnimator object
    UIDynamicItemBehavior *menuViewBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[[self scrollView]]];
    
    [menuViewBehavior setElasticity:0.2];
    
    [self.animator addBehavior:menuViewBehavior];
}

@end