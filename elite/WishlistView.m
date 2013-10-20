//
//  WishlistView.m
//  elite
//
//  Created by Andrea Barbieri on 13/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "WishlistView.h"
#import "ProductsView.h"
#import "Prodotto.h"
#import "RemoteImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "TTAlertView.h"
#import "GAI.h"

@interface WishlistView (){
    NSMutableArray *ProdottiArray;
    //ODRefreshControl *refreshControl;
    int iol;
}


@end

@implementation WishlistView
@synthesize prodotti,itemCell,urlProdotti;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Wishlist"
                                   image:[UIImage imageNamed:@"80-shopping-cart"]
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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    urlProdotti = [[NSString alloc] initWithFormat:@"%@Wishlist/get_wish_prod.php?user=%@", WEBSERVICEURL,valUser ];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    iol=0;
    ProdottiArray = [[NSMutableArray alloc] init];
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.refreshControl beginRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadProducts{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlProdotti]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    //NSLog(@"pull");
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
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    
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
    int x=0;
    for (int i = 0; i<[prodotti count]; i++) {
        
        @try {
            Prodotto *prod = [[Prodotto alloc] init];
            prod.idprodotto = [[prodotti objectAtIndex:i] objectForKey:@"ID"];
            prod.name = [[prodotti objectAtIndex:i] objectForKey:@"Name"];
            prod.prezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
            prod.oldprezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
            prod.where = [[prodotti objectAtIndex:i] objectForKey:@"NomeNegozio"];
            prod.urlfoto = [[prodotti objectAtIndex:i] objectForKey:@"ImageUrl"];
            prod.codice = [[prodotti objectAtIndex:i] objectForKey:@"PublicCode"];
            prod.categoria = [[prodotti objectAtIndex:i] objectForKey:@"Category"];
            prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
            prod.consigliato = [[prodotti objectAtIndex:i] objectForKey:@"User_upload"];
            prod.privateCodeValue = [[prodotti objectAtIndex:i] objectForKey:@"CodeValue"];
            [ProdottiArray  addObject:prod];
        }
        @catch (NSException *exception) {
            // deal with the exception
            ////NSLog(@"eccezione");
            //PreferitiView *pref = [[PreferitiView alloc] initWithNibName:@"PreferitiView" bundle:nil];
            //[self.navigationController pushViewController:pref animated:YES];
            if(x==0){
                [[[TTAlertView alloc] initWithTitle:@"Nessun prodotto!"
                                            message:@"Inserisci e consiglia un prodotto"
                                           delegate:self
                                  cancelButtonTitle:@"Continua"
                                  otherButtonTitles:nil]
                 show];
                x=1;
            }
        }
    }
    // crea la lista filtrata, inizializzandola con il numero di elementi dell'array "lista"
	filteredListContent = [[NSMutableArray alloc] initWithCapacity: [ProdottiArray count]];
	//inserisce in questa  nuova lista gli elementi della lista originale
	[filteredListContent addObjectsFromArray:ProdottiArray];
    //[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
    
    
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
        cell = itemCell;
        
    }
    
    float currentVersion = 7.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < currentVersion)
    {
        cell.nameProd.font = [UIFont fontWithName:@"Helvetica" size:19];
        cell.nameProd.textColor = [UIColor darkGrayColor];
        cell.whereProd.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.whereProd.textColor = [UIColor lightGrayColor];
        cell.Price.font = [UIFont fontWithName:@"Helvetica" size:18];
        cell.Price.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        cell.oldPrice.font = [UIFont fontWithName:@"Helvetica" size:16];
    }
    Prodotto *pro;
    //NSLog(@"entro");
    @try {
        pro = [ProdottiArray objectAtIndex:indexPath.row];
    }
    @catch (NSException *exception) {
        //NSLog(@"eccezione");
    }
    
    
    cell.nameProd.text = pro.name;
    float a = [pro.oldprezzo floatValue];
    //NSLog(@"%f",a);
    float sconto = [pro.privateCodeValue floatValue];
    a = a-(a*sconto);
    //NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    //[prod.prezzo stringByAppendingString:@"  €"];
    if ([numberString characterAtIndex:0] == ',' ) {
        numberString = [@"0" stringByAppendingString:numberString];
    }
    cell.Price.text = [numberString stringByAppendingString:@"  €"];
    
    cell.oldPrice.text =  [pro.oldprezzo stringByAppendingString:@"  €"];
    cell.whereProd.text = pro.where;
    
    
    NSArray * array = [pro.urlfoto componentsSeparatedByString:@"/"];
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@",WEBSERVICEURL,[array objectAtIndex:[array count]-1] ];
    
    [cell.prodImage setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:pro.idprodotto];
    cell.oldPrice.textAlignment = NSTextAlignmentRight;
    cell.Price.textAlignment = NSTextAlignmentRight;
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    
    return cell;
}

- (void) viewWillAppear:(BOOL)animated{
    //self.tableView.contentOffset = CGPointMake(0.0, 90.0);
    //NSLog(@"%@", urlProdotti);
    prodotti = nil;
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    
    [self.tableView reloadData];
    
}

-(void)pressedLeftButton
{
    //NSLog(@"Account");
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
// Elimina l'elemento dalla tabella e dalla lista
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //controlla se l'azione compiuta è un'eliminazione
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //elimina l'elemento dalla lista
        Prodotto *prod = [filteredListContent objectAtIndex:indexPath.row];
        [filteredListContent removeObjectAtIndex:indexPath.row];
        //elimina le'elemento dalla tabella
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *userid = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
        NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  prod.idprodotto, @"id_prod",
                                  userid, @"id_user",
                                  nil];
        
        
        NSError *error;
        NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        
        //NSLog(@"%@",postData);
        
        
        NSString *postLength = [NSString stringWithFormat:@"12321443"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlnick = [[NSString alloc] initWithFormat:@"%@/Wishlist/remove_prod.php", WEBSERVICEURL ];
        [request setURL:[NSURL URLWithString:urlnick]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        
        NSURLResponse *response;
        NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
        //NSLog(@"Reply: %@", theReply);
        
        //conrollo risposta
        if ([theReply isEqualToString:@"0"]) {
            //NSLog(@"Creo NON RIUSCITO");
        } else {
            //NSLog(@"Creo RIUSCITO");
            
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"Prodotti che desideri";
    headerLabel.font = [UIFont fontWithName:@"Helvetica" size:16];
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerView.backgroundColor = [UIColor colorWithRed:0/255.0f green:104/255.0f blue:164/255.0f alpha:0.8f];
    
    [headerView addSubview:headerLabel];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  30.0;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProductsView *detailViewController = [[ProductsView alloc] initWithNibName:@"ProductsView" bundle:nil];
    detailViewController.isWishlist = @"yes";
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.prod = [filteredListContent objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Wishlist"];
}
@end