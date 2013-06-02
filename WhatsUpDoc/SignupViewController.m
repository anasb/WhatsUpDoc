//
//  SignupViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 6/1/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "SignupViewController.h"
#import "ViewController.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

@synthesize table, client, nameTf, usernameTf, passwordTf, myScrollView, nameImg, signInBtn, bigTitle, usernameImg, passwordImg, loading, jsonDic;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.client = [MSClient clientWithApplicationURL:[NSURL URLWithString:@"https://whatsupdoc.azure-mobile.net"] applicationKey:@"LLmUeCVDYzjHdtefjnPJCdfSOzUCwo56"];
    self.table = [self.client tableWithName:@"User"];

    svos = myScrollView.contentOffset;
    
    jsonDic = [[NSMutableDictionary alloc] init];
    
    //[self signInWebService:@"abouzoubaa" andPwd:@"rhinno"];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(void)signInWebService:(NSString *)username andPwd:(NSString *)password
{
    NSURL *url = [NSURL URLWithString:@"https://whatsupdoc.azurewebsites.net"];
    
    AFHTTPClient *afClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [afClient setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", password, @"password", nil];

    NSMutableURLRequest *request = [afClient requestWithMethod:@"POST" path:@"/webservices/authenticate.aspx" parameters:params];
    
    NSLog(@"request: %@", [request description]);
    NSLog(@"params: %@", params);
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"request: %@", request);
        
        NSLog(@"JSON: %@", JSON);
        
        [self getDoctors];
//        
//        if ([[JSON objectAtIndex:1] isEqualToString:@"true"]) {
//            [self goToHomePage];
//        } else {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Wrong password/username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//            //[alert show];
//        }
        
        //[self.loading removeFromSuperview];
        //[self.view setUserInteractionEnabled:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"\n--------------------------ERROR----------------------------------\n%@\n-----------------------------------------------------------------\n", [error description]);
        NSLog(@"JSON: %@", JSON);
        //[self.loading removeFromSuperview];
        //[self.view setUserInteractionEnabled:YES];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection problem" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        //[alert show];

    }];
    [operation start];
 
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


-(void)confirm:(id)sender
{
    if ([usernameTf.text isEqualToString:@""] || [passwordTf.text isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Input all required fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
    } else {
        if (nameImg.alpha == 0) {
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
            
            
            [self signInWebService:usernameTf.text andPwd:passwordTf.text];
            
        } else {
            
            if ([nameTf.text isEqualToString:@""]) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Input all required fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert show];
                
            } else {
                
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
                
                
                [self signUpWebService:nameTf.text andUsername:usernameTf.text andPwd:passwordTf.text];
                
                

            }
            
        }

    }
    
}

- (void)getDoctors
{
    NSURL *url = [NSURL URLWithString:@"https://whatsupdoc.azurewebsites.net"];
    
    AFHTTPClient *afClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [afClient setDefaultHeader:@"Accept" value:@"application/json"];
        
    NSMutableURLRequest *request = [afClient requestWithMethod:@"GET" path:@"/webservices/doctors.aspx" parameters:nil];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                NSLog(@"JSON doctors: %@", JSON);
        
        
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        appdelegate.jsonDic = JSON;
        NSLog(@"appdele: %@", appdelegate.jsonDic);
        
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        NSLog(@"\n--------------------------ERROR----------------------------------\n%@\n-----------------------------------------------------------------\n", [error description]);
        NSLog(@"JSON doctors: %@", JSON);
        [self.loading removeFromSuperview];
        [self.view setUserInteractionEnabled:YES];

    }];
    [operation start];
    
    [self goToHomePage];
}

-(void)goToHomePage
{
    UIStoryboard*storyboard =[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    ViewController *viewC = (ViewController *)[storyboard instantiateViewControllerWithIdentifier:@"homeViewID"];
    [self.navigationController pushViewController:viewC animated:YES];
}

-(void)signIn:(id)sender
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

        }];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == nameTf) {
        [usernameTf becomeFirstResponder];
    } else if (textField == usernameTf) {
        [passwordTf becomeFirstResponder];
    } else if (textField == passwordTf) {
        [passwordTf resignFirstResponder];
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

- (void)queryAzure
{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"Username != nil"];
    
    MSQuery *query = [self.table queryWithPredicate:predicate];
    
    query.includeTotalCount = YES;
    
    [query readWithCompletion:^(NSArray *items, NSInteger totalCount, NSError *error) {
        NSLog(@"%i items: %@", totalCount, items);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
