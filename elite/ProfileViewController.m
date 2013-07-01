//
//  ProfileViewController.m
//  elite
//
//  Created by Andrea Barbieri on 11/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProfileViewController.h"
#import "ProdottoViewController.h"
#import "Prodotto.h"
#import "RemoteImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoView.h"

@interface ProfileViewController (){
    NSMutableArray *ProdottiArray;
    ODRefreshControl *refreshControl;
    int iol;
}

@end

@implementation ProfileViewController
@synthesize tabellaView,prodotti,itemCell,urlProdotti;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Profilo"
                                   image:[UIImage imageNamed:@"111-user"]
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
    //urlProdotti = @"http://eliteitalia.altervista.org/webservice/Prodotti/get_all_products.php";
    urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_all_products.php", WEBSERVICEURL ];

    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tabellaView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    iol=0;
    ProdottiArray = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
    [self setTabellaView:nil];
    [super viewDidUnload];
}
- (void) loadProducts{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlProdotti]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    NSLog(@"pull");
    prodotti = nil;
    [ProdottiArray removeAllObjects];
    [self loadProducts];
}


- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.prodotti = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadProdotti];
    [self.tabellaView reloadData];
    [refreshControl endRefreshing];
    
    
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
    return [filteredListContent count];
}


- (void) loadProdotti{
    
    for (int i = 0; i<[prodotti count]; i++) {
        Prodotto *prod = [[Prodotto alloc] init];
        prod.idprodotto = [[prodotti objectAtIndex:i] objectForKey:@"ID"];
        prod.name = [[prodotti objectAtIndex:i] objectForKey:@"Name"];
        prod.prezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
        prod.oldprezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
        prod.where = [[prodotti objectAtIndex:i] objectForKey:@"Store_ID"];
        prod.urlfoto = [[prodotti objectAtIndex:i] objectForKey:@"ImageUrl"];
        prod.categoria = [[prodotti objectAtIndex:i] objectForKey:@"Category"];
        prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
        prod.consigliato = [[prodotti objectAtIndex:i] objectForKey:@"Consigliato"];
        //prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
        [ProdottiArray  addObject:prod];
    }
    // crea la lista filtrata, inizializzandola con il numero di elementi dell'array "lista"
	filteredListContent = [[NSMutableArray alloc] initWithCapacity: [ProdottiArray count]];
	//inserisce in questa  nuova lista gli elementi della lista originale
	[filteredListContent addObjectsFromArray:ProdottiArray];
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //#define IMAGE_VIEW_TAG 99
    ProdCell *cell = (ProdCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        [[NSBundle mainBundle] loadNibNamed:@"ProdCell"
                                      owner:self options:NULL];
        /*
         //add AsyncImageView to cell
         AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 70.0f, 70.0f)];
         imageView.contentMode = UIViewContentModeScaleAspectFill;
         imageView.clipsToBounds = YES;
         imageView.tag = IMAGE_VIEW_TAG;
         [itemCell addSubview:imageView];
         //[imageView release];
         
         //common settings
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.indentationWidth = 84.0f;
         cell.indentationLevel = 1;*/
        cell = itemCell;
        
    }
    NSLog(@"entro");
    Prodotto *pro = [filteredListContent objectAtIndex:indexPath.row];
    
    
    cell.nameProd.text = pro.name;
    float a = [pro.oldprezzo floatValue];
    NSLog(@"%f",a);
    a = a-(a*0.1);
    NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    
    cell.Price.text = [numberString stringByAppendingString:@"  €"];
    cell.oldPrice.text =  [pro.oldprezzo stringByAppendingString:@"  €"];
    cell.whereProd.text = pro.where;
    cell.prodImage.layer.cornerRadius = 9.0 ;
    cell.prodImage.layer.masksToBounds = YES ;
    cell.prodImage.layer.borderColor = [UIColor whiteColor].CGColor ;
    cell.prodImage.layer.borderWidth = 3.0 ;
    
    NSArray * array = [pro.urlfoto componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@",WEBSERVICEURL ,[array objectAtIndex:[array count]-1] ];
    
    //NSLog(@"%@",[array objectAtIndex:i]);
    //NSLog(@"%@",pro.url);
    
    
    [cell.prodImage setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:pro.idprodotto];
    
    return cell;
}

- (void) viewWillAppear:(BOOL)animated{
    //self.tableView.contentOffset = CGPointMake(0.0, 90.0);
    NSLog(@"%@", urlProdotti);
    prodotti = nil;
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    [self.tabellaView reloadData];
    
}

-(void)pressedLeftButton
{
    NSLog(@"Account");
    UserInfoView *userinfo = [[UserInfoView alloc] initWithNibName:@"UserInfoView" bundle:nil];
    [self.navigationController pushViewController:userinfo animated:YES];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [filteredListContent removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.prod = [filteredListContent objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (IBAction)changeView:(id)sender {
    NSLog(@"cambio");
    if([sender selectedSegmentIndex] == 0)
    {
        NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
        self.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_user_prod.php?user=%@", WEBSERVICEURL,valUser ];
        [ProdottiArray removeAllObjects];
    	[self loadProducts];
    	
    }
    else if([sender selectedSegmentIndex] == 1)
    {
        self.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_all_products.php", WEBSERVICEURL ];
        [ProdottiArray removeAllObjects];
    	[self loadProducts];
    	
    }
}
@end
