//
//  SignupViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 6/1/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>


@interface SignupViewController : UIViewController <UITextFieldDelegate>
{
    CGPoint svos;
}

@property (nonatomic, assign) IBOutlet UIScrollView *myScrollView;
@property (nonatomic, assign) IBOutlet UILabel *bigTitle;
@property (nonatomic, retain) IBOutlet UIView *loading;

@property (nonatomic, assign) IBOutlet UITextField *usernameTf;
@property (nonatomic, assign) IBOutlet UITextField *nameTf;
@property (nonatomic, assign) IBOutlet UITextField *passwordTf;

@property (nonatomic, assign) IBOutlet UIImageView *nameImg;
@property (nonatomic, assign) IBOutlet UIImageView *usernameImg;
@property (nonatomic, assign) IBOutlet UIImageView *passwordImg;
@property (nonatomic, assign) IBOutlet UIButton *signInBtn;


@property (nonatomic, strong) NSMutableDictionary *jsonDic;
@property (nonatomic, strong) NSArray *jsonTitle;

@property (nonatomic, strong) MSClient *client;
@property (nonatomic, strong) MSTable *table;

-(IBAction)confirm:(id)sender;
-(IBAction)signIn:(id)sender;

@end
