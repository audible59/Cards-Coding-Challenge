//
//  CustomMenuViewController.m
//  CardsCodingChallenge
//
//  Created by Kevin E. Rafferty II on 8/14/14.
//  Copyright (c) 2014 com.envoy.www. All rights reserved.
//

#import "CustomMenuViewController.h"

@interface CustomMenuViewController ()

#pragma mark -
#pragma mark UIButton Properties
#pragma mark -

@property (strong, nonatomic) IBOutlet UIButton *zonesButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;
@property (strong, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *scheduleButton;
@property (strong, nonatomic) IBOutlet UIButton *homeInformationButton;

#pragma mark -
#pragma mark IBAction Methods
#pragma mark -

- (IBAction)onCloseButtonPressed:(id)sender;

@end

@implementation CustomMenuViewController

#pragma mark -
#pragma mark View Life Cycle
#pragma mark -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[self zonesButton]           setAlpha:0.0f];
//    [[self logoutButton]          setAlpha:0.0f];
//    [[self scheduleButton]        setAlpha:0.0f];
//    [[self settingsButton]        setAlpha:0.0f];
//    [[self homeInformationButton] setAlpha:0.0f];
    
    [self performSelector:@selector(beginShowAnimationChain)
               withObject:nil
               afterDelay:0.1f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark IBAction Methods
#pragma mark -

- (IBAction)onCloseButtonPressed:(id)sender
{
    [self beginHideAnimationChain];
    
    [self performSelector:@selector(performSegueDelay)
               withObject:nil
               afterDelay:1.0f];
}

#pragma mark -
#pragma mark SELECTOR Methods
#pragma mark -

- (void)performSegueDelay
{
    [self performSegueWithIdentifier:kUnwindCustomMenuViewControllerSegue
                              sender:self];
}

#pragma mark -
#pragma mark UIHelper Methods
#pragma mark -

- (BOOL)beginShowAnimationChain
{
    BOOL returnBOOL = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.zonesButton.frame = CGRectMake(self.zonesButton.frame.origin.x,
                                                             self.zonesButton.frame.origin.y - 20,
                                                             self.zonesButton.frame.size.width,
                                                             self.zonesButton.frame.size.height);
                         
//                         [[self zonesButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.scheduleButton.frame = CGRectMake(self.scheduleButton.frame.origin.x,
                                                                self.scheduleButton.frame.origin.y - 20,
                                                                self.scheduleButton.frame.size.width,
                                                                self.scheduleButton.frame.size.height);
                         
//                         [[self scheduleButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.homeInformationButton.frame = CGRectMake(self.homeInformationButton.frame.origin.x,
                                                                       self.homeInformationButton.frame.origin.y - 20,
                                                                       self.homeInformationButton.frame.size.width,
                                                                       self.homeInformationButton.frame.size.height);
                         
//                         [[self homeInformationButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.settingsButton.frame = CGRectMake(self.settingsButton.frame.origin.x,
                                                                self.settingsButton.frame.origin.y - 20,
                                                                self.settingsButton.frame.size.width,
                                                                self.settingsButton.frame.size.height);
                         
//                         [[self settingsButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.logoutButton.frame = CGRectMake(self.logoutButton.frame.origin.x,
                                                              self.logoutButton.frame.origin.y - 20,
                                                              self.logoutButton.frame.size.width,
                                                              self.logoutButton.frame.size.height);
                         
//                         [[self logoutButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    return returnBOOL;
}

- (BOOL)beginHideAnimationChain
{
    BOOL returnBOOL = NO;
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.zonesButton.frame = CGRectMake(self.zonesButton.frame.origin.x,
                                                             self.zonesButton.frame.origin.y + 20,
                                                             self.zonesButton.frame.size.width,
                                                             self.zonesButton.frame.size.height);
                         
                         //                         [[self zonesButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.scheduleButton.frame = CGRectMake(self.scheduleButton.frame.origin.x,
                                                                self.scheduleButton.frame.origin.y + 20,
                                                                self.scheduleButton.frame.size.width,
                                                                self.scheduleButton.frame.size.height);
                         
                         //                         [[self scheduleButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.homeInformationButton.frame = CGRectMake(self.homeInformationButton.frame.origin.x,
                                                                       self.homeInformationButton.frame.origin.y + 20,
                                                                       self.homeInformationButton.frame.size.width,
                                                                       self.homeInformationButton.frame.size.height);
                         
                         //                         [[self homeInformationButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.settingsButton.frame = CGRectMake(self.settingsButton.frame.origin.x,
                                                                self.settingsButton.frame.origin.y + 20,
                                                                self.settingsButton.frame.size.width,
                                                                self.settingsButton.frame.size.height);
                         
                         //                         [[self settingsButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [UIView animateWithDuration:0.3f
                          delay:0.1f
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.logoutButton.frame = CGRectMake(self.logoutButton.frame.origin.x,
                                                              self.logoutButton.frame.origin.y + 20,
                                                              self.logoutButton.frame.size.width,
                                                              self.logoutButton.frame.size.height);
                         
                         //                         [[self logoutButton] setAlpha:1.0f];
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    return returnBOOL;
}

#pragma mark -
#pragma mark - Segue Navigation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender
{
}

@end