//
//  LoadDetailViewController.m
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoadDetailViewController.h"

@interface LoadDetailViewController (){
    NSArray *list;
    NSMutableArray *listLoad;
}

@end

@implementation LoadDetailViewController
@synthesize tabellaView,imageProd,imageViewProd;

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Consiglia" style:UIBarButtonItemStylePlain target:self action:@selector(pressedFinishButton)];
    [anotherButton setTintColor:[UIColor greenColor]];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    CGRect tbFrame = [tabellaView frame];
    tbFrame.size.height = 500;
    [tabellaView setFrame:tbFrame];
    
    list = [[NSArray alloc] initWithObjects:@"Nome",@"Foto",@"Prezzo",@"Categoria",@"Negozio",@"Descrizione", nil];
    listLoad = [[NSMutableArray alloc] initWithObjects:@"Inserisci",@"Ok!",@"Seleziona",@"Seleziona",@"Seleziona",@"", nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    imageViewProd.image = imageProd;
    //imageProd.layer.cornerRadius = 20;//half of the width
    //imageViewProd.layer.borderColor=[UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f].CGColor;
    imageViewProd.layer.borderColor = [UIColor whiteColor].CGColor;
    imageViewProd.layer.borderWidth=1.0f;
    
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
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [listLoad objectAtIndex:indexPath.row];
    if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"bollasok"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    
    
    
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


- (void)viewDidUnload {
    [self setTabellaView:nil];
    [self setImageViewProd:nil];
    [super viewDidUnload];
}
@end
