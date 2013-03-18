//
//  LoginViewController.m
//  elite
//
//  Created by Andrea on 06/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //Fai il login
    //check tutorial
    NSLog(@"Tutorial?");
    //[self checkTutorial];
    
    
    
    
    
    
}

-(void) checkTutorial{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"Tutorial"]){
        //proceed with app normally
        NSLog(@"accettato");
        NewProductViewController *newprod = [[NewProductViewController alloc] initWithNibName:@"NewProductViewController" bundle:nil];
        NSArray *viewControllerArray =[NSArray arrayWithObjects:newprod,nil];
        
        UITabBarController *tabBarController = [[UITabBarController alloc] init];
        
        tabBarController.viewControllers = viewControllerArray;
        
        self.tabBarController = tabBarController;
        
        self.view = self.tabBarController.view;
    }
    else{
        //show terms
        NSLog(@"NO accettato");
        [self loadTutorial];
    }
}

- (void) loadTutorial{
    NSLog(@"loaded");
    TutorialViewController *tutorial = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:tutorial];
    [self.view addSubview:navVC.view];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tutorial"];
    NSLog(@"EX");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)Login:(id)sender {
    
    //if(loginOK){
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentTabBarController];
    //}
}
@end