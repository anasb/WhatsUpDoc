//
//  SignupViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 6/1/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "SignupViewController.h"
#import "HomeViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize table, client, nameTf, usernameTf, passwordTf, myScrollView, nameImg, signInBtn, bigTitle, usernameImg, passwordImg, loading, confirmBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - Views
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    svos = myScrollView.contentOffset;

    //jsonDic = [[NSMutableDictionary alloc] init];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self bypassLogin];
}

#pragma mark - Web Services calls
-(void)signInWebService:(NSString *)username andPwd:(NSString *)password
{
    // ----------------------------- PARAMS ----------------------------------------------------------------------
    
    AFHTTPClient *newClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://whatsupdoc.azurewebsites.net"]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password", nil];
    [newClient setParameterEncoding:AFJSONParameterEncoding];
    
    // ----------------------------- REQUEST ---------------------------------------------------------------------
    
    [newClient getPath:@"/webservices/authenticate.aspx" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        NSError *error;
        
        NSArray *responseDic = (NSArray *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        
        // Right username & pwd
        if ([[responseDic objectAtIndex:1] isEqualToString:@"true"]) {
            
            [self getDoctors];
            [self goToHomePage];
            
        // Wrong username / pwd
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong password or username" delegate:self cancelButtonTitle:@"Try again" otherButtonTitles:nil];
            [alert show];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Sorry, there was a connection problem! Please try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    
}

-(void)signUpWebService:(NSString *)name andUsername:(NSString *)username andPwd:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:@"http://whatsupdoc.azurewebsites.net"];
    AFHTTPClient *afClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [afClient setDefaultHeader:@"Accept" value:@"application/json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];
    NSMutableURLRequest *request = [afClient requestWithMethod:@"POST" path:@"/webservices/authenticate.aspx" parameters:params];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"JSON: %@", JSON);
        
        if ([JSON isEqualToString:@"true"]) {
            [self goToHomePage];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong password/username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
        
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"\n--------------------------ERROR----------------------------------\n%@\n-----------------------------------------------------------------\n", [error description]);
        NSLog(@"JSON: %@", JSON);
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    }];
    [operation start];
    
}

#pragma mark - Getting list of doctors
- (void)getDoctors
{
    
    // ----------------------------- PARAMS ----------------------------------------------------------------------
    
    AFHTTPClient *newClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"https://whatsupdoc.azurewebsites.net"]];
    [newClient setParameterEncoding:AFJSONParameterEncoding];
    
    // ----------------------------- REQUEST ---------------------------------------------------------------------
    
    [newClient getPath:@"/webservices/doctors.aspx" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error;
        NSDictionary *responseDic = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];

        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegate.doctorsJsonDic = responseDic;
        appdelegate.specialtiesArray = [responseDic valueForKey:@"Title"];
        appdelegate.doctorsArray = [responseDic valueForKey:@"Name"];
        
        NSLog(@"Doctors: \n%@", responseDic);
        
        [self parseResults];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error] (doctors): %@", error.localizedDescription);
        
    }];
    
}

#pragma mark - Parse json
-(void)parseResults
{
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSArray *newArray = [NSArray arrayWithArray:appdelegate.specialtiesArray];
    NSSet *set = [NSSet setWithArray:newArray];
    
    newArray = [set allObjects];
    appdelegate.specialtiesArray = nil;
    appdelegate.specialtiesArray = [NSMutableArray arrayWithArray:newArray];
    
    NSLog(@"After parse:%@", appdelegate.specialtiesArray);
}

#pragma mark - Move on to Homepage
-(void)goToHomePage
{
    [self.loading removeFromSuperview];
    [self.view setUserInteractionEnabled:YES];

    UIStoryboard*storyboard =[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    HomeViewController *viewC = (HomeViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewID"];
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - IBActions

// Switch between signin & signup
-(IBAction)switchLogin:(id)sender
{
    if (nameImg.alpha == 0) {
        
        [UIView animateWithDuration:0.5 animations:^{

            [usernameImg setCenter:CGPointMake(usernameImg.center.x, usernameImg.center.y+51)];
            [usernameTf setCenter:CGPointMake(usernameTf.center.x, usernameTf.center.y+51)];
            [passwordImg setCenter:CGPointMake(passwordImg.center.x, passwordImg.center.y+51)];
            [passwordTf setCenter:CGPointMake(passwordTf.center.x, passwordTf.center.y+51)];
            
            [nameImg setAlpha:1];
            [nameTf setAlpha:1];
            [bigTitle setText:@"Create an account"];
            [signInBtn setTitle:@"Already have an account?" forState:UIControlStateNormal];
            [confirmBtn setTitle:@"Sign up" forState:UIControlStateNormal];
        }];
        
        
    } else {

        [UIView animateWithDuration:0.5 animations:^{
            
            [usernameImg setCenter:CGPointMake(usernameImg.center.x, usernameImg.center.y-51)];
            [usernameTf setCenter:CGPointMake(usernameTf.center.x, usernameTf.center.y-51)];
            [passwordImg setCenter:CGPointMake(passwordImg.center.x, passwordImg.center.y-51)];
            [passwordTf setCenter:CGPointMake(passwordTf.center.x, passwordTf.center.y-51)];
            
            [nameImg setAlpha:0];
            [nameTf setAlpha:0];
            [bigTitle setText:@"Sign in"];
            [signInBtn setTitle:@"Create an account" forState:UIControlStateNormal];
            [confirmBtn setTitle:@"Sign in" forState:UIControlStateNormal];
        }];
    }

}

// Hit confirm button: signin/signup action
-(void)confirm:(id)sender
{
    // Hide keyboard
    [nameTf resignFirstResponder];
    [usernameTf resignFirstResponder];
    [passwordTf resignFirstResponder];
    
    // Make sure all fields are full
    if ([usernameTf.text isEqualToString:@""] || [passwordTf.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Input all required fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    } else {
        // No name: signin
        if (nameImg.alpha == 0) {
            
            [self showLoader];
            
            // API Call
            [self signInWebService:usernameTf.text andPwd:passwordTf.text];
            
        // Name exist: signup
        } else {
            
            if ([nameTf.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Input all required fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            } else {
                
                [self showLoader];
                
                // API Call
                [self signUpWebService:nameTf.text andUsername:usernameTf.text andPwd:passwordTf.text];
                
            }
            
        }
        
    }
    
}

-(void)showLoader
{
    [self.view setUserInteractionEnabled:NO];
    
    loading = [[UIView alloc] initWithFrame:CGRectMake(90, 140, 150, 150)];
    loading.backgroundColor = [UIColor blackColor];
    loading.alpha = 0.7 ;
    [loading.layer setMasksToBounds:YES];
    [loading.layer setCornerRadius:10];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(65, 65, 20, 20)];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 110, 25)];
    label.text = @"Loading...";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:18];
    
    [loading addSubview:activityIndicator];
    [loading addSubview:label];
    [self.view addSubview:loading];

}

#pragma mark - TextField delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameTf) {
        [usernameTf becomeFirstResponder];
    } else if (textField == usernameTf) {
        [passwordTf becomeFirstResponder];
    } else if (textField == passwordTf) {
        [passwordTf resignFirstResponder];
        [self confirm:nil];
    }
    
    return NO;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint pt;
    CGRect rc = [textField bounds];
    rc = [textField convertRect:rc toView:myScrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 120;
    [myScrollView setContentOffset:pt animated:YES];
    
    [myScrollView setScrollEnabled:NO];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [myScrollView setContentOffset:svos animated:YES];
    [myScrollView setScrollEnabled:YES];
}

#pragma mark - Memory Management
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Cheats - DON'T FORGET TO DELETE
-(void)bypassLogin
{
    [self showLoader];
    [self signInWebService:@"abouzoubaa" andPwd:@"rhinno"];
}

@end
