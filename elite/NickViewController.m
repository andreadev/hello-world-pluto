//
//  NickViewController.m
//  elite
//
//  Created by Andrea Barbieri on 18/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "NickViewController.h"
#import "User.h"
#import "AppDelegate.h"

@interface NickViewController (){
    UITextField *nick;
    User *utente;
}

@end

@implementation NickViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Accedi" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [self populateUserDetails];
    /*
    UIImage *menuButtonImage = [UIImage imageNamed:@"111-user"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    if (indexPath.row==0) {
        //cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor= [UIColor blackColor];
        cell.textLabel.text = @"Nickname";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        nick = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        nick.font = [UIFont fontWithName:@"Heilvetica" size:18];
        nick.textColor = [UIColor blackColor];
        nick.backgroundColor = [UIColor clearColor];
        nick.delegate =self;
        nick.textAlignment = UITextAlignmentLeft;
        nick.highlighted = YES;
        nick.placeholder = @"Nickname";
        nick.keyboardType = UIKeyboardTypeEmailAddress;
        nick.returnKeyType = UIReturnKeyNext;
        [cell.contentView addSubview:nick];
    }
    
    return cell;
}

- (void) pressedLeftButton{
    
    
    
    NSLog(@"PRESSED: %@",nick.text );
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              nick.text, @"username",
                              utente.idfacebook, @"facebook",
                              utente.email, @"email",
                              utente.token, @"token",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://eliteitalia.altervista.org/webservice/Utenti/create_facebook_user.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    
    //conrollo risposta
    if ([theReply rangeOfString:@"1"].location == NSNotFound) {
        NSLog(@"REGISTRAZIONE NON RIUSCITA");
    } else {
        NSLog(@"REGISTRAZIONE RIUSCITO");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Registred"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nick.text forKey:@"User"];
        [defaults synchronize];
        NSLog(@"nick %@", nick.text );
        
        NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
        NSLog(@"nick2 %@", testoSalvato );
        
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate presentTabBarController];
        
        
    }
    
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
                 utente = [[User alloc] init];
                 utente.name = user.name;
                 utente.idfacebook = user.id;
                 utente.email= [user objectForKey:@"email"];
                 FBAccessTokenData *tokenData = [[FBSession activeSession] accessTokenData];
                 utente.token = tokenData.accessToken;
                 
                 NSLog(@" TOKEN %@", tokenData.accessToken);
                 NSLog(@"USER: %@,ID %@, MAIL %@",utente.user,utente.idfacebook,utente.email);
        
             }
         }];
    }
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
