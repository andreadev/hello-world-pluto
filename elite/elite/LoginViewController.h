//
//  LoginViewController.h
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewProductViewController.h"
#import "TutorialViewController.h"


@interface LoginViewController : UIViewController

@property (strong, nonatomic) UITabBarController *tabBarController;

- (IBAction)Login:(id)sender; 

@end
