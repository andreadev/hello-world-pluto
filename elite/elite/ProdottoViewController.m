//
//  ProdottoViewController.m
//  elite
//
//  Created by Andrea Barbieri on 25/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdottoViewController.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>

@interface ProdottoViewController (){
    NSArray *lista;
    NSMutableArray *datiList;
    NSString *numberString;
    
}

@end

@implementation ProdottoViewController
@synthesize prod,name,where,prezzo,oldprezzo,from,descrizione,codice,imageProd,Scrollview,tabellaView;

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
    lista = [[NSArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consiliato da:", @"Codice Sconto:",@"Descrizione" ,nil];
    datiList = [[NSMutableArray alloc] init];
    //lista = [[NSMutableArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consigliato da:",@"Codice Sconto:","Descrizione:", nil];
    
    [Scrollview setScrollEnabled:YES];//Abilitiamo lo scroll
    
    [Scrollview setContentSize:(CGSizeMake(320,600))];
    
    CGRect tbFrame = [tabellaView frame];
    tbFrame.size.height = 500;
    [tabellaView setFrame:tbFrame];
    /*queste sono<span id="more-1890"></span> le dimesione 320 larghezza e 900 la lunghezza*/
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    
    
    self.name.text = prod.name;
    //self.where.text = prod.where;
    float a = [prod.oldprezzo floatValue];
    NSLog(@"%f",a);
    a = a-(a*0.1);
    NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    self.prezzo.text = numberString;
    self.oldprezzo.text = prod.oldprezzo;
    self.from.text = prod.consigliato;
    self.descrizione.text = prod.desc;
    //self.title = prod.name;
    self.imageProd.layer.cornerRadius = 9.0 ;
    self.imageProd.layer.masksToBounds = YES ;
    self.imageProd.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.imageProd.layer.borderWidth = 3.0 ;
    //imageProd.image = image;
    NSArray * array = [prod.url componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/product_images/thumb/%@",[array objectAtIndex:[array count]-1] ];
    
    [imageProd setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"53-house"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return [lista count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    //lista = [[NSArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consiliato da:", @"Codice Sconto:",@"Descrizione" ,nil];
    cell.textLabel.text = [lista objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = prod.where;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1){
        cell.detailTextLabel.text = prod.prezzo;
    }
    else if (indexPath.row == 2){
        cell.detailTextLabel.text = numberString;
    }
    else if (indexPath.row == 3){
        cell.detailTextLabel.text = prod.consigliato;
    }
    else if (indexPath.row == 4){
        cell.detailTextLabel.text = @"NONE";
    }
    else if (indexPath.row == 5){
        cell.detailTextLabel.text = prod.desc;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 5){
        
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        UINavigationController *navDet = [[UINavigationController alloc] initWithRootViewController:detail];
        detail.detail = prod.desc;
        
        [self presentModalViewController:navDet animated:YES];

        
    }
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setWhere:nil];
    [self setPrezzo:nil];
    [self setPrezzo:nil];
    [self setFrom:nil];
    [self setDescrizione:nil];
    [self setCodice:nil];
    [self setImageProd:nil];
    [self setTabellaView:nil];
    [super viewDidUnload];
}
@end
