//
//  ViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 01/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (assign, nonatomic) IBOutlet UIImageView *nextVisitTitle;
@property (assign, nonatomic) IBOutlet UILabel *nextVisitLabel;

@property (nonatomic, retain) NSDictionary *nextVisit;

@end
