//
//  AddViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "AddViewController.h"
#import "AddListViewController.h"
#import "SignupViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

@synthesize myTableView, specialty, doctor, datePicker, toolbar, visitDate, visitTime, lastSelected;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

#pragma mark - Views Management
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"add-bg.png"]]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add-bg.png"]];
    [myTableView setBackgroundView:imgView];
    
    specialty = @"";
    doctor = @"";
    visitDate = @"";
    visitTime = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSpecialty:) name:@"specialtyChosen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDoctorName:) name:@"doctorChosen" object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selected = [myTableView indexPathForSelectedRow];
    if (selected) [myTableView deselectRowAtIndexPath:selected animated:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStyleDone target:self action:@selector(saveAndQuit)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    [myTableView reloadData];
}

#pragma mark - NSNotificationCenter callbacks
-(void)setSpecialty:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    specialty = [dict objectForKey:@"specialty"];
}

-(void)setDoctorName:(NSNotification *)notification
{
    NSDictionary *dict = [notification userInfo];
    doctor = [dict objectForKey:@"doctor"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        if (![specialty isEqualToString:@""]) {
            return 2;
        } else {
            return 1;
        }
        
    }
    
    return 2;

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Doctor";
    } else {
        return @"Date";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Specialty";
        
            if ([specialty isEqualToString:@""]) {
                cell.detailTextLabel.text = @"Browse specialties";
            
            } else {
                cell.detailTextLabel.text = specialty;
            }
            
        } else {
            cell.textLabel.text = @"Name";
            
            if ([doctor isEqualToString:@""]) {
                cell.detailTextLabel.text = @"Select your doctor";
            } else {
                cell.detailTextLabel.text = doctor;
            }
        }
        
    } else {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"Day";
            
            if ([visitDate isEqualToString:@""]) {
                cell.detailTextLabel.text = @"--/--/--";
            
            } else {
                cell.detailTextLabel.text = visitDate;
            }
            
        } else {
            cell.textLabel.text = @"Time";
            
            if ([visitTime isEqualToString:@""]) {
                cell.detailTextLabel.text = @"--:--";
            
            } else {
                cell.detailTextLabel.text = visitTime;
            }
            
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 264, 320, 400)];
            [datePicker setDatePickerMode:UIDatePickerModeDate];
            
            toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 220, 320, 50)];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            toolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(dismissDate)],
                             [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveDate)],
                             nil];
            [toolbar sizeToFit];
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:toolbar];
            [[[UIApplication sharedApplication] keyWindow] addSubview:datePicker];
            
        } else {
            
            datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 264, 320, 400)];
            [datePicker setDatePickerMode:UIDatePickerModeTime];
            [datePicker setMinuteInterval:15];
            
            toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 220, 320, 50)];
            toolbar.barStyle = UIBarStyleBlackTranslucent;
            toolbar.items = [NSArray arrayWithObjects:
                             [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonSystemItemCancel target:self action:@selector(dismissDate)],
                             [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                             [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(saveTime)],
                             nil];
            [toolbar sizeToFit];
            
            [[[UIApplication sharedApplication] keyWindow] addSubview:toolbar];
            [[[UIApplication sharedApplication] keyWindow] addSubview:datePicker];
        }
        
    }
}


#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddListViewController *listVC = (AddListViewController *)segue.destinationViewController;
    NSIndexPath *indexPath =  [myTableView indexPathForSelectedRow];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            listVC.listNumber = 0;
            
        } else {
            listVC.listNumber = 1;
        }
        
    }
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    NSIndexPath *indexPath =  [myTableView indexPathForSelectedRow];
    lastSelected = [[NSIndexPath alloc] init];
    lastSelected = indexPath;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            return YES;
            
        } else {
            return YES;
        }
        
    } else {
        
        if (indexPath.row == 0) {
            return NO;
            
        } else {
            return NO;
        }
    }
}

#pragma mark - Save & Quit functions
-(void)saveTime
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm"];
    NSDate *date = [datePicker date];
    visitTime = [dateFormat stringFromDate:date];
    [myTableView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        [datePicker setFrame:CGRectMake(0, 320, 320, 400)];
        [toolbar setFrame:CGRectMake(0, 320, 320, 50)];
    } completion:^(BOOL finished) {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
    }];
}

-(void)dismissDate
{
    [UIView animateWithDuration:0.2 animations:^{
        [datePicker setFrame:CGRectMake(0, 320, 320, 400)];
        [toolbar setFrame:CGRectMake(0, 320, 320, 50)];
    } completion:^(BOOL finished) {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
    }];
}

-(void)saveDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM/dd/yyyy"];
    NSDate *date = [datePicker date];
    visitDate = [dateFormat stringFromDate:date];
    [myTableView reloadData];
    
    [UIView animateWithDuration:0.2 animations:^{
        [datePicker setFrame:CGRectMake(0, 320, 320, 400)];
        [toolbar setFrame:CGRectMake(0, 320, 320, 50)];
    } completion:^(BOOL finished) {
        [datePicker removeFromSuperview];
        [toolbar removeFromSuperview];
    }];
}


-(void)saveAndQuit
{
    NSString *date = [NSString stringWithFormat:@"%@ - %@", visitTime, visitDate];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:date, @"date", specialty, @"specialty", doctor, @"name", @"75 Francis St. Boston, MA 02115", @"address" , nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"nextVisitAdded" object:nil userInfo:dict];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)cancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
