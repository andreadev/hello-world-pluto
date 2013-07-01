
//
//  LoginViewController.m
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SingUpViewController.h"
#import "LoginSiteViewController.h"
#import "NickViewController.h"


@interface LoginViewController (){
    NSArray *lista;
}

@end

@implementation LoginViewController
@synthesize tabellaView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Default"]];
        self.view.backgroundColor = background;
        self.tabellaView.backgroundColor = [UIColor clearColor];
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"did");
    
    lista = [[NSArray alloc] initWithObjects:@"Accedi",@"Registrati", nil];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.isOpen){
        NSLog(@"login");
        // Yes, so just open the session (this won't display any UX).
        NSLog(@"LOGIN DID LOAD");
        [appDelegate presentTabBarController];
     
    }
    else if ([[NSUserDefaults standardUserDefaults] stringForKey:@"Username"] != nil){
        NSLog(@"login auto from App");
        [appDelegate presentTabBarController];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.isOpen){
        NSLog(@"login");
        // Yes, so just open the session (this won't display any UX).
        NSLog(@"LOGIN will LOAD");
        [appDelegate presentTabBarController];
        
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.trackedViewName = @"Login Screen";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [lista count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    static NSString *CellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        
    }
    
    // Configure the cell.
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = [lista objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        
        LoginSiteViewController *loginSite = [[LoginSiteViewController alloc] initWithNibName:@"LoginSiteViewController" bundle:nil];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:loginSite animated:YES];
    
    }
    if (indexPath.row == 1 ){
        SingUpViewController *singUP = [[SingUpViewController alloc] initWithNibName:@"SingUpViewController" bundle:nil];
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:singUP animated:YES];
       
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)openSessionWithAllowLoginUI:(BOOL)allowLoginUI {
    NSLog(@"open session");
    NSArray *permissions = @[
                             @"basic_info",
                             @"email",
                             @"user_likes"];
    return [FBSession openActiveSessionWithReadPermissions:permissions
                                              allowLoginUI:allowLoginUI
                                         completionHandler:^(FBSession *session,
                                                             FBSessionState state,
                                                             NSError *error) {
                                             NSLog(@"qua");
                                             [self sessionStateChanged:session state:state error:error];
                                         }];
}

- (IBAction)Login:(id)sender {
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    [appDelegate openSessionWithAllowLoginUI:YES];
    
    
    /*
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        //[self openSession];
        NSLog(@"LOGIN BOTTONE");
        
    } else {
        // No, display the login page.
        NSLog(@"LOGIN BOTTONE ELSE");
        [appDelegate.session closeAndClearTokenInformation];
        appDelegate.session = [[FBSession alloc] init];
        
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,FBSessionState state, NSError *error) {
            [self openSession];
            //[self sessionStateChanged:session state:state error:error];
         
        }];
        //[self openSession];
        
    }
*/
    
    /*
    if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        NSLog(@"ifffffff");
        //[appDelegate presentTabBarController];
        //[self.view addSubview:appDelegate.tabBarController.view];
        
        ///////AUTOLOGIN////////
        //sessione aperta quindi autologin: ovviamente poi va visto anche dal lato server elite
        
    } else {
        NSLog(@"LOGIN BOTTONE ELSE");
        [appDelegate.session closeAndClearTokenInformation];
        appDelegate.session = [[FBSession alloc] init];
        
 
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
        [self openSession];
        
    }*/

    

}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
             }
         }];
    }
}

/*- (void)openSession
{
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:@"email", nil];
    
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    NSLog(@"test");
    
}
*/
/*
 * Callback for session changes.
 */
- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    NSLog(@"apro aa");
    switch (state) {
        case FBSessionStateOpen:
            NSLog(@"apro");
            if (!error) {
                // We have a valid session
                NSLog(@"User session found");
                NSLog(@"OPEN SESSION");
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"Registred"]!=YES){
                    NSLog(@"Non Registrato");
                    NickViewController *nick = [[NickViewController alloc] initWithNibName:@"NickViewController" bundle:nil];
                    [self.navigationController pushViewController:nick animated:YES];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Registred"];
                    
                }
                else{
                    NSLog(@"Else");
                    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate  presentTabBarController];
                }
            }
            break;
        case FBSessionStateClosed:{ NSLog(@"Chiusa"); }
        case FBSessionStateClosedLoginFailed:{ NSLog(@"Fail"); }
            [FBSession.activeSession closeAndClearTokenInformation];
            break;
        default:
            { NSLog(@"Niente"); }
            break;
    }
    
    /*[[NSNotificationCenter defaultCenter]
     postNotificationName:FBSessionStateChangedNotification
     object:session];*/
    
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

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
                NSLog(@"OPEN SESSION");
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"Registred"]!=YES){
                NSLog(@"Non Registrato");
                NickViewController *nick = [[NickViewController alloc] initWithNibName:@"NickViewController" bundle:nil];
                [self.navigationController pushViewController:nick animated:YES];
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
                
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}*/

- (void)viewDidUnload {
    [self setTabellaView:nil];
    [super viewDidUnload];
}
@end