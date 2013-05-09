
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
        self.title= @"Login";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    lista = [[NSArray alloc] initWithObjects:@"Accedi",@"Registrati", nil];
    
    //Fai il login
    //check tutorial
    NSLog(@"Tutorial?");
    //[self loadTutorial];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
        
        NSLog(@"apro sessione");
        [appDelegate presentTabBarController];
        
    }
    
    

    
    
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
    
    cell.textLabel.text = [lista objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];*/
     // ...
    
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


- (void) viewWillAppear:(BOOL)animated{
    //[self loadTutorial];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
        NSLog(@"apro sessione");
        
        
        [appDelegate presentTabBarController];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // Yes, so just open the session (this won't display any UX).
        [self openSession];
        NSLog(@"apro sessione");
        
    } else {
        // No, display the login page.
        [appDelegate.session closeAndClearTokenInformation];
        appDelegate.session = [[FBSession alloc] init];
        
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,FBSessionState state, NSError *error) {
            [self sessionStateChanged:session state:state error:error];
            
        }];
        [self openSession];
        
    }

    
    
    /*if (appDelegate.session.isOpen) {
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate presentTabBarController];
        
        ///////AUTOLOGIN////////
        //sessione aperta quindi autologin: ovviamente poi va visto anche dal lato server elite
        
    } else {
        [appDelegate.session closeAndClearTokenInformation];
        appDelegate.session = [[FBSession alloc] init];
 
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
     
        
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

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    //NSString * token = [[FBSession activeSession] accessToken];
    
    [self populateUserDetails];
}

- (void)fbDialogLogin:(NSString *)token expirationDate:(NSDate *)expirationDate {
    NSLog(@"%@",token);
    
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (state) {
        case FBSessionStateOpen: {
                NSLog(@"testo");
                //[self openSession];
                [appDelegate presentTabBarController];
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
}
- (void)viewDidUnload {
    [self setTabellaView:nil];
    [super viewDidUnload];
}
@end