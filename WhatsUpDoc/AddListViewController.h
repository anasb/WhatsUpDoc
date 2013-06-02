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

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSString *category;

@property (nonatomic, assign) int listNumber;

@property (nonatomic, strong) NSMutableDictionary *jsonDic;

@end
