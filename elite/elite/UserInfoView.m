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
@synthesize name,nick,altro,userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SampleBackground"]];
        self.view.backgroundColor = background;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userImage.layer.cornerRadius = 9.0 ;
    self.userImage.layer.masksToBounds = YES ;
    self.userImage.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.userImage.layer.borderWidth = 3.0 ;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Esci" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    nick.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    NSString *id_facebook = [[NSUserDefaults standardUserDefaults] stringForKey:@"FacebookID"];
    if (![id_facebook isEqualToString:@"NO"]) {
        NSData *responseData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://graph.facebook.com/%@",id_facebook ]]];
        NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:responseData
                                                             options:kNilOptions
                                                               error:nil];
        NSString *image_url= [[NSString alloc] initWithFormat:@"http://graph.facebook.com/%@/picture?width=150&height=150",id_facebook ];
        name.text = [dict objectForKey:@"name"];
        [userImage setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:id_facebook];
    }
    else{
        userImage.image = [UIImage imageNamed:@"111-user"];
    }
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)logOut {
    NSString *id_facebook = [[NSUserDefaults standardUserDefaults] stringForKey:@"FacebookID"];
    if (![id_facebook isEqualToString:@"NO"]) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"Username"];
    }
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.navigationController popViewControllerAnimated:YES];
    [appDelegate presentLoginController];
}
@end
