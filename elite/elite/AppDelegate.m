//
//  AppDelegate.m
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize tabBarController,loginController,homeController,tutorial,preferitiView,Product,preferitiList;
@synthesize session;

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [session handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"back_nav.png"] forBarMetrics:UIBarMetricsDefault];
    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_nav"]];
    [[UINavigationBar appearance] setTitleView:navImage];
    [[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                UITextAttributeTextColor: [UIColor whiteColor],
                          UITextAttributeTextShadowColor: [UIColor clearColor],
                         UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)],
                                     UITextAttributeFont: [UIFont fontWithName:@"Gill Sans" size:20.0f]
     }];
     
     
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Tutorial"]!=YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Tutorial"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"logged"];
        
    }
    
    
    
    Product = [[NewProductViewController alloc] initWithNibName:@"NewProductViewController" bundle:nil];
    homeController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    homeController.session = session;
    //preferitiView = [[PreferitiView alloc] initWithNibName:@"PreferitiView" bundle:nil];
    preferitiList = [[PreferitiListView alloc] initWithNibName:@"PreferitiListView" bundle:nil];
    UINavigationController *navPref = [[UINavigationController alloc] initWithRootViewController:preferitiList];
    UINavigationController *navHome = [[UINavigationController alloc] initWithRootViewController:homeController];
    UINavigationController *navProd = [[UINavigationController alloc] initWithRootViewController:Product];
    NSArray *viewControllerArray =[NSArray arrayWithObjects: navHome,navProd, navPref, nil];
    
    tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = viewControllerArray;
    loginController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
    //[self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"tab-back.png"]];
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor grayColor]];
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Tutorial"]){
        //proceed with app normally
        NSLog(@"accettato");
        nav.navigationBarHidden = NO;
        self.window.rootViewController = nav;
        
    }
    else{
        //show terms
        NSLog(@"NO accettato");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tutorial"];
        tutorial = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
        //UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:tutorial];
        //[self presentModalViewController:tutorial animated:YES];
        self.window.rootViewController = tutorial;
    }

   
    
    //self.window.rootViewController = loginController;
    
    
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

-(void)presentLoginController{
    
    loginController = [[LoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginController];
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



@end
