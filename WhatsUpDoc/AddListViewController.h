//
//  AddListViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddListViewController : UITableViewController

@property (nonatomic, assign) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSDictionary *jsonDic;

@property (nonatomic, strong) AppDelegate *appdelegate;

@property (nonatomic, assign) int listNumber;

@end
