//
//  UserInfoView.m
//  elite
//
//  Created by Andrea Barbieri on 20/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "UserInfoView.h"
#import "AppDelegate.h"

@interface UserInfoView ()

@end

@implementation UserInfoView
@synthesize name,nick,altro;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [self populateUserDetails];
}
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //self.title = user.name;
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
                 
                name.text = user.name;
                nick.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
                 altro.text = [user objectForKey:@"email"];
             }
         }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logOut:(id)sender {
    [FBSession.activeSession closeAndClearTokenInformation];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentLoginController];
}
@end
