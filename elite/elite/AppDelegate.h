//
//  AppDelegate.h
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "NewProductViewController.h"
#import "TutorialViewController.h"
#import "HomeViewController.h"
#import "PreferitiView.h"



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) PreferitiView *preferitiView;
@property (strong, nonatomic) HomeViewController *homeController;
@property (strong, nonatomic) TutorialViewController *tutorial;
@property (strong, nonatomic) FBSession *session;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)presentTabBarController;
-(void)addTabBarController;

@end
