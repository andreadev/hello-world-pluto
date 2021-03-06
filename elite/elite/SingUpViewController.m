//
//  SingUpViewController.m
//  elite
//
//  Created by Andrea Barbieri on 09/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "SingUpViewController.h"
#import "AppDelegate.h"
#import "TTAlertView.h"

@interface SingUpViewController (){
    UITextField *mail;
    UITextField *pass;
    UITextField *nick;
    
}

@end

@implementation SingUpViewController
@synthesize postParams;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Registrati" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    UIColor *background = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"SampleBackground"]];
    self.view.backgroundColor = background;
    
    //self.navigationController.navigationBarHidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pressedLeftButton{
    [mail resignFirstResponder];
    [pass resignFirstResponder];
    [nick resignFirstResponder];
    if ([mail.text isEqualToString:@""] || [pass.text isEqualToString:@""] || [nick.text isEqualToString:@""]) {
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"Compila tutti i campi"
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
        
        return;
    }
    NSLog(@"PRESSED: %@ -- %@ -- %@",mail.text,pass.text,nick.text );
    NSString *appToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"Token"];
    NSLog(@"%@", appToken);
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              mail.text, @"email",
                              pass.text, @"password",
                              nick.text, @"username",
                              appToken, @"apptoken",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlsing = [[NSString alloc] initWithFormat:@"%@Utenti/create_user.php", WEBSERVICEURL ];
    [request setURL:[NSURL URLWithString:urlsing]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    if ([theReply isEqualToString:@"0"]) {
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"Il nick name da te scelto è già utilizzato"
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
    }
    else if([theReply isEqualToString:@"-1"]) {
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"La mail e' già utilizzata"
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
    }
    else {
        NSLog(@"Creo RIUSCITO");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Registred"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Tutorial"];
        [[NSUserDefaults standardUserDefaults] setObject:nick.text forKey:@"Username"];
        NSLog(@"%@",theReply);
        theReply = [theReply stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSLog(@"%@",theReply);
        [[NSUserDefaults standardUserDefaults] setObject:theReply forKey:@"UserID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"FacebookID"];
        //[self.navigationController popToRootViewControllerAnimated:YES];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate presentTabBarController];
    }

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
    return 3;
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
    if (indexPath.row==2){
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"Nickname";
        cell.textLabel.font = [UIFont fontWithName:@"Gill Sans" size:18];
        nick = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        nick.font = [UIFont fontWithName:@"Gill Sans" size:18];
        nick.textColor = [UIColor blackColor];
        nick.backgroundColor = [UIColor clearColor];
        nick.delegate =self;
        nick.textAlignment = NSTextAlignmentLeft;
        nick.highlighted = YES;
        nick.placeholder = @"Nickname";
        nick.keyboardType = UIKeyboardTypeDefault;
        nick.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:nick];
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
