//
//  ViewAppointmentsViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAppointmentsViewController : UITableViewController

@property (nonatomic, assign) IBOutlet UITableView *myTableView;

@property (nonatomic, retain) NSDictionary *visit1;
@property (nonatomic, retain) NSDictionary *visit2;

@end
