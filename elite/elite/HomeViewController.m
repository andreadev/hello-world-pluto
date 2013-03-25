//
//  HomeViewController.m
//  elite
//
//  Created by Andrea Barbieri on 22/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "HomeViewController.h"
#import "ProdottoViewController.h"
#import "Prodotto.h"

@interface HomeViewController (){
    NSMutableArray *ProdottiArray;
}

@end

@implementation HomeViewController
@synthesize prodotti,itemCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Home"
                                   image:[UIImage imageNamed:@"53-house.png"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    ProdottiArray = [[NSMutableArray alloc] init];
    [self populateUserDetails];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://eliteitalia.altervista.org/webservice/Prodotti/get_all_products.php"]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.prodotti = json;
    [self.tableView reloadData];
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
    return [prodotti count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ProdCell *cell = (ProdCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ProdCell"
                                      owner:self options:NULL];
        cell = itemCell;
    }
    NSLog(@"entro");
    NSLog(@"%@",[prodotti objectAtIndex:indexPath.row]);
    NSString *url = [[NSString alloc] initWithFormat:@"http://%@",[[prodotti objectAtIndex:indexPath.row] objectForKey:@"ImageUrl"]] ;
    
    NSURL *imageURL = [[NSURL alloc] initWithString:url];
    //NSURL *imageURL = [[NSURL alloc] initWithString:@"http://eliteitalia.altervista.org/webservice/product_images/mela.jpg"];
    
    cell.prodImage.image = [UIImage imageNamed:@"53-house"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.prodImage.image = image;
        });
    });
    
    Prodotto *prod = [[Prodotto alloc] init];
    
    prod.name = [[prodotti objectAtIndex:indexPath.row] objectForKey:@"Name"];
    prod.prezzo = [[prodotti objectAtIndex:indexPath.row] objectForKey:@"Price"];
    prod.oldprezzo = [[prodotti objectAtIndex:indexPath.row] objectForKey:@"Price"];
    prod.where = [[prodotti objectAtIndex:indexPath.row] objectForKey:@"Store_ID"];
    
    [ProdottiArray  addObject:prod];
    
    cell.nameProd.text = prod.name;
    cell.Price.text = prod.prezzo;
    cell.oldPrice.text =  prod.oldprezzo;
    cell.whereProd.text = prod.where;
    
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
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 self.title = user.name;
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
             }
         }];
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.prod = [ProdottiArray objectAtIndex:indexPath.row];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
