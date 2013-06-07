//
//  AppDelegate.h
//  WhatsUpDoc
//
//  Created by Anas Bouzoubaa on 01/06/13.
//  Copyright (c) 2013 RHINNO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) NSDictionary *doctorsJsonDic;
@property (nonatomic, retain) NSMutableArray *specialtiesArray;
@property (nonatomic, retain) NSMutableArray *doctorsArray;

@end
