//
//  LoginSiteViewController.m
//  elite
//
//  Created by Andrea Barbieri on 09/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoginSiteViewController.h"

@interface LoginSiteViewController (){
    UITextField *mail;
    UITextField *pass;
    
}

@end

@implementation LoginSiteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *menuButtonImage = [UIImage imageNamed:@"06-magnify"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
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
    
    NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
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
        cell.textLabel.font = [UIFont fontWithName:@"Gill Sans" size:18];
        mail = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        mail.font = [UIFont fontWithName:@"Gill Sans" size:18];
        mail.textColor = [UIColor blackColor];
        mail.backgroundColor = [UIColor clearColor];
        mail.delegate =self;
        mail.textAlignment = UITextAlignmentLeft;
        mail.highlighted = YES;
        mail.placeholder = @"example@example.com";
        mail.keyboardType = UIKeyboardTypeEmailAddress;
        mail.returnKeyType = UIReturnKeyNext;
        [cell.contentView addSubview:mail];
    }
    if (indexPath.row==1){
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = @"Password";
        cell.textLabel.font = [UIFont fontWithName:@"Gill Sans" size:18];
        pass = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 200, 30)];
        pass.font = [UIFont fontWithName:@"Gill Sans" size:18];
        pass.textColor = [UIColor blackColor];
        pass.backgroundColor = [UIColor clearColor];
        pass.delegate =self;
        pass.textAlignment = UITextAlignmentLeft;
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
