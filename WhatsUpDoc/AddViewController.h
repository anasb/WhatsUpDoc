//
//  AddViewController.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddViewController : UITableViewController


@property (assign, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (retain, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) NSString *specialty;
@property (strong, nonatomic) NSString *doctor;
@property (strong, nonatomic) NSString *visitDate;
@property (strong, nonatomic) NSString *visitTime;



@end
