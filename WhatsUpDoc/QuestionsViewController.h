//
//  QuestionsViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionsViewController : UITableViewController

@property (nonatomic, assign) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) NSMutableArray *questions;

@end
