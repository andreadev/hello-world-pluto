//
//  LoginViewController.h
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewProductViewController.h"
#import "GAITrackedViewController.h"

extern NSString *const FBSessionStateChangedNotification;


@interface LoginViewController : GAITrackedViewController <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITabBarController *tabBarController;

@property (weak, nonatomic) IBOutlet UITableView *tabellaView;
- (IBAction)Login:(id)sender; 

@end
