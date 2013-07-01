//
//  CategoryView.m
//  elite
//
//  Created by Andrea Barbieri on 29/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView (){
    NSMutableArray *categorie;
    
}

@end

@implementation CategoryView
@synthesize loadDetail,search;

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
    self.title = @"Categorie";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pressedFinishButton)];
    self.navigationItem.leftBarButtonItem = anotherButton;
    
    
    
    categorie = [[NSMutableArray alloc] initWithObjects:@"Abbigliamento e Accessori",@"Arte",@"Audio",@"Bellezza e Salute",@"Casa, Arredamento e Bricolage",@"Collezionismo",@"CD e DVD",@"Giocattoli e Modellismo",@"Infanzia e Premaman",@"Informatica",@"Libri, Riviste e Fumetti",@"Orologi, Occhiali e Gioielli",@"Musica e Strumenti Musicali",@"Telefonia",@"Videogiochi e Console",@"Altro", nil];

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
    return [categorie count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [categorie objectAtIndex:indexPath.row];
    
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",[categorie objectAtIndex:indexPath.row]);
    
    loadDetail.categorianome = [categorie objectAtIndex:indexPath.row];
    loadDetail.categoriaid = [[NSString alloc] initWithFormat:@"%d", indexPath.row ];
    
    search.categorianome = [categorie objectAtIndex:indexPath.row];
    search.categoriaid = [[NSString alloc] initWithFormat:@"%d", indexPath.row ];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)done:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) pressedFinishButton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
