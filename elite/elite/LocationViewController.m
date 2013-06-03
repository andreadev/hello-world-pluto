//
//  LocationViewController.m
//  elite
//
//  Created by Andrea Barbieri on 22/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LocationViewController.h"
#import "Shop.h"

@interface LocationViewController (){
    NSMutableArray *negozi;
}

@end

@implementation LocationViewController
@synthesize shops,longitudine,latitudine,prodView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Negozi";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"qui");
    negozi = [[NSMutableArray alloc] init];
    [self seeNegozi];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [negozi count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    Shop *detailShop = [negozi objectAtIndex:indexPath.row];
    
    cell.textLabel.text = detailShop.nome;
    cell.detailTextLabel.text = detailShop.indirizzo;
    NSLog(@"%@",detailShop.nome);
    
    return cell;
}

- (void)seeNegozi {
    NSString * url = [[NSString alloc] initWithFormat:@"http://cosapensidime.ilbello.com/webservice/geoloc/get_stores_get.php?lat=%@&lng=%@&dist=50", latitudine, longitudine];
    NSLog(@"%@",url);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
    
}


- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    shops = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadNegozi];
    [self.tableView reloadData];
    
    
    
}

- (void) loadNegozi{
    for (int i =0 ; i< [shops count]; i++) {
        Shop *nuovoShop = [[Shop alloc] init];
        
       nuovoShop.nome = [[shops objectAtIndex:i] objectForKey:@"Name"];
        nuovoShop.indirizzo= [[shops objectAtIndex:i] objectForKey:@"Address"];
        NSLog(@"NEGOZIO");
        NSLog(@"%@",nuovoShop.nome);
        [negozi addObject:nuovoShop];
    }
    
    NSLog(@"count: %d", [negozi count]);
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
    Shop *detailShop = [negozi objectAtIndex:indexPath.row];
    
    NSString * nam = detailShop.nome;
    NSLog(@"NOME %@",detailShop.nome);
    NSLog(@"INDIRIZZO %@",detailShop.indirizzo);
    [prodView setNegozio:nam];
    //prodView.negozio = nam;
    prodView.moreShop.titleLabel.text = nam;
    //[prodView.moreShop setTitle:detailShop.nome forState:UIControlStateNormal];
    
    
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)done:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
