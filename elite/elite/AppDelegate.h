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
#import "PreferitiListView.h"
#import "TakePhotoViewController.h"
#import "ProfileViewController.h"
#import "WishlistView.h"

extern NSString *const FBSessionStateChangedNotification;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) LoginViewController *loginController;
@property (strong, nonatomic) NewProductViewController *Product;
@property (strong, nonatomic) PreferitiView *preferitiView;
@property (strong, nonatomic) HomeViewController *homeController;
@property (strong, nonatomic) TutorialViewController *tutorial;
@property (strong, nonatomic) PreferitiListView *preferitiList;
@property (strong, nonatomic) TakePhotoViewController *loadProd;
@property (strong, nonatomic) ProfileViewController *profile;
@property (strong, nonatomic) WishlistView *wishlist;
@property (strong, nonatomic) FBSession *session;

+(AppDelegate *) getApplicationDelegate;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)presentTabBarController;
-(void)presentLoginController;
-(void)addTabBarController;

@end
