//
//  LoginSiteViewController.m
//  elite
//
//  Created by Andrea Barbieri on 09/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoginSiteViewController.h"
#import "AppDelegate.h"

@interface LoginSiteViewController (){
    UITextField *mail;
    UITextField *pass;
    
}

@end

@implementation LoginSiteViewController
@synthesize postParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Accedi" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SampleBackground"]];
    self.view.backgroundColor = background;
    //UIImage *menuButtonImage = [UIImage imageNamed:@"111-user"];
    //UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    //btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    
    
    //UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    //[btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem.title=@"Fine";
    //self.navigationItem.rightBarButtonItem = menuBarButton;
    //self.navigationController.navigationBarHidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIButton *passwordLost = [UIButton buttonWithType:UIButtonTypeCustom];
    [passwordLost setTitle:@"Password Dimenticata?" forState:UIControlStateNormal];
    [passwordLost setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    passwordLost.frame = CGRectMake(0,130, 320, 30);
    passwordLost.titleLabel.textAlignment = NSTextAlignmentCenter;
    passwordLost.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    [passwordLost addTarget:self action:@selector(passLost) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:passwordLost];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) passLost{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.eliteadvice.it/forgot_psw.php"]];
}

- (void) pressedLeftButton{
    
    //NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              mail.text, @"username",
                              pass.text, @"password",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlogin = [[NSString alloc] initWithFormat:@"%@Utenti/login_user_iphone.php", WEBSERVICEURL ];
    [request setURL:[NSURL URLWithString:urlogin]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    
    if ([theReply isEqualToString:@"0"]) {
        //NSLog(@"LOGIN NON RIUSCITO");
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"Login non corretta!Riprova.."
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
    } else {
        //NSLog(@"LOGIN RIUSCITO");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tutorial"];
        NSString *valueSave = mail.text;
        [[NSUserDefaults standardUserDefaults] setObject:valueSave forKey:@"Username"];
        theReply = [theReply stringByReplacingOccurrencesOfString:@" " withString:@""];
        //NSLog(@"%@",theReply);
        [[NSUserDefaults standardUserDefaults] setObject:theReply forKey:@"UserID"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FacebookID"];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate presentTabBarController];
        
        
    }
    ////NSLog(@"%d",[json count]);
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    if (indexPath.row==0) {
        //cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor= [UIColor blackColor];
        cell.textLabel.text = @"Email";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        mail = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        mail.font = [UIFont fontWithName:@"Helvetica" size:18];
        mail.textColor = [UIColor blackColor];
        mail.backgroundColor = [UIColor clearColor];
        mail.delegate =self;
        mail.textAlignment = NSTextAlignmentLeft;
        mail.highlighted = YES;
        mail.placeholder = @"example@example.com";
        mail.keyboardType = UIKeyboardTypeEmailAddress;
        mail.returnKeyType = UIReturnKeyNext;
        [cell.contentView addSubview:mail];
    }
    if (indexPath.row==1){
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"Password";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        pass = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        pass.font = [UIFont fontWithName:@"Helvetica" size:18];
        pass.textColor = [UIColor blackColor];
        pass.backgroundColor = [UIColor clearColor];
        pass.delegate =self;
        pass.textAlignment = NSTextAlignmentLeft;
        pass.highlighted = YES;
        pass.placeholder = @"Required";
        pass.keyboardType = UIKeyboardTypeDefault;
        pass.returnKeyType = UIReturnKeyDone;
        pass.secureTextEntry = YES;
        [cell.contentView addSubview:pass];
    }
    
    
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
