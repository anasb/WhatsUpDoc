//
//  HomeViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 01/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "HomeViewController.h"
#import "SignupViewController.h"
#import "AddViewController.h"
#import "ViewAppointmentsViewController.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <QuartzCore/QuartzCore.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

@synthesize nextVisitTitle, nextVisit, nextVisitLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // If no next visit
    if (!nextVisit) {
        [nextVisitTitle setHidden:YES];
        [nextVisitLabel setHidden:YES];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNextVisit:) name:@"nextVisitAdded" object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationItem.hidesBackButton = YES;
}

- (void)updateNextVisit:(NSNotification *)notification
{
    nextVisit = [[NSDictionary alloc] initWithDictionary:[notification userInfo]];
    
    nextVisitLabel.text = [NSString stringWithFormat:@"%@: %@", [nextVisit objectForKey:@"name"], [nextVisit objectForKey:@"date"]];
    
    [nextVisitTitle setHidden:NO];
    [nextVisitLabel setHidden:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
