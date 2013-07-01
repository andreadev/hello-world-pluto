//
//  AppDelegate.m
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "AppDelegate.h"
#import "GAI.h"

NSString *const FBSessionStateChangedNotification =@"it.plutodev.Elite:FBSessionStateChangedNotification";
NSString *const WEBSERVICEURL =@"http://www.eliteadvice.it/webservice/";

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController,loginController,homeController,tutorial,preferitiView,Product,preferitiList,loadProd,profile,wishlist,navProd;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //registro push notifications
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    // Optional: set debug to YES for extra debugging information.
    [GAI sharedInstance].debug = YES;
    // Create tracker instance.
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-20727450-10"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //DESIGN GRAPHIC
    
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
      [NSValue valueWithUIOffset:UIOffsetMake(0, 1)], UITextAttributeTextShadowOffset,
      [UIFont fontWithName:@"Helvetica" size:8.5], UITextAttributeFont,
      nil] forState:UIControlStateNormal];
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"back_nav.png"] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"back_nav.png"]]];
    
    
    
    //LOAD VIEWS
    
    loadProd = [[TakePhotoViewController alloc] initWithNibName:@"TakePhotoViewController" bundle:nil];
    homeController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    homeController.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_all_products.php", WEBSERVICEURL ];
    preferitiList = [[PreferitiListView alloc] initWithNibName:@"PreferitiListView" bundle:nil];
    profile = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    wishlist = [[WishlistView alloc] initWithNibName:@"WishlistView" bundle:nil];
    
    //LOAD NAVIGATION
    
    UINavigationController *navPref = [[UINavigationController alloc] initWithRootViewController:preferitiList];
    [navPref.navigationBar setTintColor:[UIColor whiteColor]];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeController];
    [navHome.navigationBar setTintColor:[UIColor whiteColor]];
    navProd = [[UINavigationController alloc] initWithRootViewController:loadProd];
    [navProd.navigationBar setTintColor:[UIColor whiteColor]];
    UINavigationController *navProfile = [[UINavigationController alloc] initWithRootViewController:profile];
    [navProfile.navigationBar setTintColor:[UIColor whiteColor]];
    UINavigationController *navWish = [[UINavigationController alloc] initWithRootViewController:wishlist];
    [navWish.navigationBar setTintColor:[UIColor whiteColor]];
    
    //TABBAR VIEWS
    
    NSArray *viewControllerArray =[NSArray arrayWithObjects: navHome,navWish, navProd,navProfile, navPref, nil];
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = viewControllerArray;
    
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Tutorial"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Tutorial"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Logged"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Registred"];
        
        
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Tutorial"]){
        //proceed with app normally
        NSLog(@"TUTORIAL SI");
        
        if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
            // Yes, so just open the session (this won't display any UX).
            
            NSLog(@"LOGIN did LOAD");
            [self presentTabBarController];
            
        }
        else{
            loginController = [[LoginViewController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
            [nav.navigationBar setTintColor:[UIColor whiteColor]];
            self.window.rootViewController = nav;
        }
    }
    else{
        
        NSLog(@"TUTORIAL NO");
        tutorial = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
        self.window.rootViewController = tutorial;
    }
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}
/*
 //FAI UNA ROBA DEL GENERE
- (void)showLoginView
{
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    [self.window.rootViewController presentViewController:loginViewController animated:YES completion:NULL];
}
*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"elite" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"elite.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

-(void)presentTabBarController{
    self.window.rootViewController = tabBarController;
}
-(void)presentHomeController{
    [navProd popToRootViewControllerAnimated:NO];
    [tabBarController setSelectedIndex:0];
}

-(void)presentLoginController{
    
    loginController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    [nav.navigationBar setTintColor:[UIColor whiteColor]];
    self.window.rootViewController = nav;
}

+(AppDelegate *) getApplicationDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(void)addTabBarController{
    
    [self.window removeFromSuperview];
    self.window.rootViewController = tabBarController;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                NSLog(@"OPEN SESSION");
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"Registred"]!=YES){
                    NSLog(@"Non Registrato");
                    NickViewController *nick = [[NickViewController alloc] initWithNibName:@"NickViewController" bundle:nil];
                    
                    [loginController.navigationController pushViewController:nick animated:YES];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Registred"];
                    
                }
                else{
                    NSLog(@"Else");
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate  presentTabBarController];
                }
            }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

/*
 * Opens a Facebook session and optionally shows the login UX.
 */
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSArray *permissions = @[
                             @"basic_info",
                             @"email",
                             @"user_likes"];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             [self sessionStateChanged:session
                                                                 state:state
                                                                 error:error];
                                         }];
}

- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    //NSString *str = [NSString stringWithFormat:@"%@",deviceToken];
    //NSLog(@"This is device token%@", deviceToken);
    NSString* str = [[[[deviceToken description]
                                stringByReplacingOccurrencesOfString: @"<" withString: @""]
                               stringByReplacingOccurrencesOfString: @">" withString: @""]
                              stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    NSLog(@"%@",str);
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"Token"];
    
}
- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}
-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
}

@end
