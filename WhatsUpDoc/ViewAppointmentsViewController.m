//
//  ViewAppointmentsViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "ViewAppointmentsViewController.h"

@interface ViewAppointmentsViewController ()

@end

@implementation ViewAppointmentsViewController

@synthesize myTableView, visit1, visit2;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"add-bg.png"]]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add-bg.png"]];
    [myTableView setBackgroundView:imgView];
    
    visit1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"10:30am - 07/05/13", @"date", @"Nephrologist", @"specialty", @"Dr Julien Pham, MD, MPH", @"name", @"75 Francis St. Boston, MA 02115", @"address" , nil];
    visit2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"2:00pm - 08/01/13", @"date", @"Pediatrician", @"specialty", @"Dr Andrey Ostrovsky", @"name", @"300 Longwood Ave Boston, MA 02115", @"address" , nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [visit1 objectForKey:@"specialty"];
            cell.detailTextLabel.text = [visit1 objectForKey:@"name"];
        } else {
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = [visit1 objectForKey:@"address"];
        }
        
    } else {
        
        if (indexPath.row == 0) {
            cell.textLabel.text = [visit2 objectForKey:@"specialty"];
            cell.detailTextLabel.text = [visit2 objectForKey:@"name"];
        } else {
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = [visit2 objectForKey:@"address"];
        }
        
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [visit1 objectForKey:@"date"];
    } else {
        return [visit2 objectForKey:@"date"];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
