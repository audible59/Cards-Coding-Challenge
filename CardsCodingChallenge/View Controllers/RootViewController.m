//
//  ViewController.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/12/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UIScrollViewDelegate>

#pragma mark -
#pragma mark PRIVATE NSMutableArray Property
#pragma mark -

@property (nonatomic, strong) NSMutableArray *pageViews;

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
    
    // Set up the array to hold the views for each page
    self.pageViews = [[NSMutableArray alloc] init];
    
    for(NSInteger i = 0; i < 100; ++i)
    {
        [self.pageViews addObject:[NSNull null]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    // Set up the content size of the scroll view
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    
    [[self scrollView] setContentSize:CGSizeMake(pagesScrollViewSize.width * 100,
                                                 pagesScrollViewSize.height)];
    
    // Load the initial set of pages that are on screen
    [self loadVisiblePages];
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
    // Load the pages that are now on screen
    [self loadVisiblePages];
}

#pragma mark -
#pragma mark Helper Methods
#pragma mark -

- (void)loadVisiblePages
{
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    NSLog(@"Page Number - %li", (long)page);
    
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
    
    for(NSInteger i = lastPage + 1; i < 100; i++)
    {
        [self purgePage:i];
    }
}

- (void)loadPage:(NSInteger)page
{
    if(page < 0 || page >= 100)
    {
        // If it's outside the range of what we have to display, then do nothing
        return;
    }
    
    // Load an individual page, first checking if you've already loaded it
    UIView *pageView = [[self pageViews] objectAtIndex:page];
    
    if((NSNull *)pageView == [NSNull null])
    {
        CGRect frame = self.scrollView.bounds;
        
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame          = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallCardBG.png"]];
        
        [tempImageView setContentMode:UIViewContentModeScaleAspectFit];
        [tempImageView setFrame:frame];
        
        [[self scrollView] addSubview:tempImageView];
        
        [[self pageViews] replaceObjectAtIndex:page
                                    withObject:tempImageView];
    }
}

- (void)purgePage:(NSInteger)page
{
    if (page < 0 || page >= 100)
    {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [[self pageViews] objectAtIndex:page];
    
    if((NSNull *)pageView != [NSNull null])
    {
        [pageView removeFromSuperview];
        
        [[self pageViews] replaceObjectAtIndex:page
                                    withObject:[NSNull null]];
    }
}

- (void)initializeScrollView
{
    int imageCountInt = 4;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.scrollView.frame.origin.x,
                                                                     self.scrollView.frame.origin.y,
                                                                     self.scrollView.frame.size.width,
                                                                     self.scrollView.frame.size.height)];
    
    [[self scrollView] setDelegate:self];
    [[self scrollView] setPagingEnabled:YES];
    [[self scrollView] setBackgroundColor:[UIColor lightGrayColor]];
    [[self scrollView] setShowsVerticalScrollIndicator:NO];
    [[self scrollView] setShowsHorizontalScrollIndicator:NO];
    
    for(int i = 0; i < imageCountInt; i++)
    {
        CGFloat xOrigin = i * self.scrollView.bounds.size.width;
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(xOrigin + 20,
                                                                    0,
                                                                    self.scrollView.bounds.size.width,
                                                                    self.scrollView.bounds.size.height)];
        
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smallCardBG.png"]];
        
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempView.frame.origin.x,
                                                                       tempView.frame.origin.y - 30,
                                                                       10,
                                                                       30)];
        
        [tempLabel setTextColor:[UIColor darkGrayColor]];
        [tempLabel setTextAlignment:NSTextAlignmentCenter];
        [tempLabel setText:[NSString stringWithFormat:@"%i", i]];
        
        [tempView addSubview:tempImageView];
        [tempView addSubview:tempLabel];
        
        [[self scrollView] addSubview:tempView];
    }
    
    [[self scrollView] setContentSize:CGSizeMake(self.scrollView.bounds.size.width * imageCountInt,
                                                 self.scrollView.bounds.size.height)];
    
    [[self view] addSubview:[self scrollView]];
}

@end