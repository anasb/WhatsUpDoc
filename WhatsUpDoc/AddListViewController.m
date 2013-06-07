//
//  AddListViewController.m
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 02/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import "AddListViewController.h"
#import "AddViewController.h"
#import "AppDelegate.h"

@interface AddListViewController ()

@end

@implementation AddListViewController

@synthesize dataArray, category, listNumber, myTableView, jsonDic, appdelegate;

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
    
    jsonDic = [[NSDictionary alloc] init];
    appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    jsonDic = appdelegate.doctorsJsonDic;
    
    NSLog(@"[AddList:viewDidLoad] jsonDic:%@", jsonDic);
    
    [self setUpData];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selected = [myTableView indexPathForSelectedRow];
    if (selected) [myTableView deselectRowAtIndexPath:selected animated:YES];
}

- (void)setUpData
{
    if (listNumber == 0) {
        
        category = @"Specialties";
        dataArray = [[NSMutableArray alloc] initWithArray:appdelegate.specialtiesArray];
        
    } else if (listNumber == 1) {
        
        category = @"Doctors";
        AddViewController *addView = [[self.navigationController viewControllers] objectAtIndex:2];
        
        dataArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<[appdelegate.doctorsArray count]; i++) {
            
            if ([[[appdelegate.doctorsJsonDic valueForKey:@"Title"] objectAtIndex:i] isEqualToString:addView.specialty]) {
                
                [dataArray addObject:[[appdelegate.doctorsJsonDic valueForKey:@"Name"] objectAtIndex:i]];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return category;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   
    if (listNumber == 0) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:cell.textLabel.text, @"specialty", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"specialtyChosen" object:nil userInfo:dict];
        
    } else if (listNumber == 1) {
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:cell.textLabel.text, @"doctor", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doctorChosen" object:nil userInfo:dict];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
