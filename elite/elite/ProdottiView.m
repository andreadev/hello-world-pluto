//
//  ProdottiView.m
//  elite
//
//  Created by Andrea Barbieri on 02/09/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdottiView.h"
#import "ProductsView.h"
#import "Prodotto.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchView.h"
#import "AppDelegate.h"
#import "GAI.h"
#import "Reachability.h"


@interface ProdottiView (){
    NSMutableArray *ProdottiArray;
    // NSMutableArray *TmpTitle;
    int scopeButtonPressedIndexNumber;
    NSString *url;
    int iol;
}

@end

@implementation ProdottiView

@synthesize prodotti,itemCell,urlProdotti,ProdottiArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    //Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    iol=0;
    ProdottiArray = [[NSMutableArray alloc] init];
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSLog(@"%@",urlProdotti);
    prodotti = nil;
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Result"];
    
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
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
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
            prod.address = [[prodotti objectAtIndex:i] objectForKey:@"StoreAddress"];
            prod.distance = [[prodotti objectAtIndex:i] objectForKey:@"Distance"];
            prod.privateCodeValue = [[prodotti objectAtIndex:i] objectForKey:@"CodeValue"];
            [ProdottiArray  addObject:prod];
    
        }
        @catch (NSException *exception) {
            // deal with the exception
            //NSLog(@"eccezione");
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
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
}

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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
        cell.nameProd.font = [UIFont fontWithName:@"Helvetica" size:18];
        cell.nameProd.textColor = [UIColor darkGrayColor];
        cell.whereProd.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.whereProd.textColor = [UIColor lightGrayColor];
        cell.Price.font = [UIFont fontWithName:@"Helvetica" size:16];
        cell.Price.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        cell.oldPrice.font = [UIFont fontWithName:@"Helvetica" size:16];
    }
    
    NSLog(@"entro");
    Prodotto *pro = [ProdottiArray objectAtIndex:indexPath.row];
    
    
    cell.nameProd.text = pro.name;
    float a = [pro.oldprezzo floatValue];
    NSLog(@"%f",a);
    float sconto = [pro.privateCodeValue floatValue];
    a = a-(a*sconto);
    NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    //[prod.prezzo stringByAppendingString:@"  €"];
    cell.Price.text = [numberString stringByAppendingString:@"  €"];
    
    cell.oldPrice.text =  [pro.oldprezzo stringByAppendingString:@"  €"];
    cell.whereProd.text = pro.where;
    
    
    NSLog(@"%@",url);
    cell.prodImage.layer.cornerRadius = 9.0 ;
    cell.prodImage.layer.masksToBounds = YES ;
    cell.prodImage.layer.borderColor = [UIColor whiteColor].CGColor ;
    cell.prodImage.layer.borderWidth = 3.0 ;
    
    NSArray * array = [pro.urlfoto componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@",WEBSERVICEURL,[array objectAtIndex:[array count]-1] ];
    
    //NSLog(@"%@",[array objectAtIndex:i]);
    NSLog(@"%@",pro.urlfoto);
    
    [cell.prodImage setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:pro.idprodotto];
    cell.oldPrice.textAlignment = NSTextAlignmentRight;
    cell.Price.textAlignment = NSTextAlignmentRight;
    
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    return cell;
}

- (void) viewWillAppear:(BOOL)animated{
    
    
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
    return [ProdottiArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
    ProductsView *detailViewController = [[ProductsView alloc] initWithNibName:@"ProductsView" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.prod = [ProdottiArray objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
