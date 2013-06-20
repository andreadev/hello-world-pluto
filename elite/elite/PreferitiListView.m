//
//  PreferitiListView.m
//  elite
//
//  Created by Andrea Barbieri on 18/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "PreferitiListView.h"
#import "User.h"
#import "PreferitiView.h"
#import "AppDelegate.h"

@interface PreferitiListView (){
    NSMutableArray *AmiciArray;
    PreferitiView *pre;
}

@end

@implementation PreferitiListView
@synthesize preferiti;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Preferiti"
                                   image:[UIImage imageNamed:@"29-heart"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *menuButtonImage = [UIImage imageNamed:@"111-user"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    AmiciArray = [[NSMutableArray alloc] init];
    pre = [[PreferitiView alloc] initWithNibName:@"PreferitiView" bundle:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self pressedLeftButton];
    [self loadPreferiti];
}

- (void) loadPreferiti{
   
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    
    NSString *urlPref = [[NSString alloc] initWithFormat:@"%@Preferiti/getpreferiti.php?nick=%@",WEBSERVICEURL, valUser];
    NSLog(@"%@",urlPref);
    
    //NSError *error = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPref] error:&error];
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPref] options:NSDataReadingUncached error:&error];
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
            //[error release];
        } else {
            NSLog(@"Data has loaded successfully.");
        }
        /*NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPref]];
        if (data == nil) {
            [self.navigationController pushViewController:pre animated:YES];
        }
        else{
            NSLog(@"ramo else");*/
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
}


- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.preferiti = json;
    NSLog(@"asd");
    if([preferiti count] == 0){
        NSLog(@"ciao");
        [self.navigationController pushViewController:pre animated:YES];
    }
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    
    NSLog(@"%@",preferiti);
    [self loadPrefer];
    
    [self.tableView reloadData];
    
    
}

- (void) loadPrefer{
    
    for (int i = 0; i<[preferiti count]; i++) {
        
        User *amico = [[User alloc] init];
        NSLog(@"ecco");
        amico.name = [[preferiti objectAtIndex:i] objectForKey:@"name_f"];
        amico.idfacebook = [[preferiti objectAtIndex:i] objectForKey:@"id_f"];
        //prod.consigliato = [[prodotti objectAtIndex:i] objectForKey:@"Consigliato"];
        //prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
            [AmiciArray  addObject:amico];
    }
}

- (void) pressedLeftButton{
    [self.navigationController pushViewController:pre animated:YES];
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
    return [AmiciArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    User *amico = [AmiciArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = amico.name;
    cell.detailTextLabel.text = amico.idfacebook;
    
    // Configure the cell...
    
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
