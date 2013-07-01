//
//  LocalizeViewController.m
//  elite
//
//  Created by Andrea Barbieri on 07/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LocalizeViewController.h"

@interface LocalizeViewController (){
    NSMutableArray *negozi;
}

@end

@implementation LocalizeViewController
@synthesize shops,latitudine,longitudine,shopSelected,loadDetail;

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
    NSLog(@"qui");
    shopSelected.nome = @"Negozio";
    self.title = @"Negozi";
    negozi = [[NSMutableArray alloc] init];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pressedFinishButton)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    
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

- (void) viewWillAppear:(BOOL)animated{
    [negozi removeAllObjects];
    [self seeNegozi];
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
    //http://www.eliteadvice.it/webservice/geoloc/get_products_get.php?lat=45&lng=11
    NSString * url = [[NSString alloc] initWithFormat:@"http://www.eliteadvice.it/webservice/geoloc/get_stores_get.php?lat=%@&lng=%@&dist=50", latitudine, longitudine];
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
        @try {
            Shop *nuovoShop = [[Shop alloc] init];
            nuovoShop.idnegozio = [[shops objectAtIndex:i] objectForKey:@"ID"];
            nuovoShop.nome = [[shops objectAtIndex:i] objectForKey:@"Name"];
            nuovoShop.indirizzo= [[shops objectAtIndex:i] objectForKey:@"Address"];
            NSLog(@"NEGOZIO");
            NSLog(@"%@",nuovoShop.nome);
            [negozi addObject:nuovoShop];
        }
        @catch (NSException *exception) {
            NSLog(@"No negozi");
        }
        
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
    shopSelected = [negozi objectAtIndex:indexPath.row];
    NSString * nam = shopSelected.nome;
    NSLog(@"NOME %@",nam);
    NSLog(@"INDIRIZZO %@",shopSelected.indirizzo);
    //loadDetail.negozio =nam;
    //prodView.negozio = nam;
    //prodView.moreShop.titleLabel.text = nam;
    //[prodView.moreShop setTitle:detailShop.nome forState:UIControlStateNormal];
    
    loadDetail.negozionome= nam;
    loadDetail.negozioid = shopSelected.idnegozio;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) pressedFinishButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
