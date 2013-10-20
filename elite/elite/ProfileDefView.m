//
//  ProfileDefView.m
//  elite
//
//  Created by Andrea Barbieri on 23/08/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProfileDefView.h"
#import "ProductsView.h"
#import "Prodotto.h"
#import "RemoteImageView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UserInfoView.h"
#import "GAI.h"

@interface ProfileDefView (){
    NSMutableArray *ProdottiArray;
    int iol;
    BOOL isConsigliato;
    ProductsView *detailViewController;
}

@end

@implementation ProfileDefView

@synthesize prodotti,itemCell,urlProdotti;

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
    
    isConsigliato = true;
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    self.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_user_prod.php?user=%@", WEBSERVICEURL,valUser ];
    detailViewController.isProfilo = @"YES";
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Account" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    iol=0;
        /*
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:UITextAttributeFont];
    [segmentConsigli setTitleTextAttributes:attributes
                                   forState:UIControlStateNormal];
    
    
    [self.tableView addSubview:segmentConsigli];
    [self.view.superview addSubview:segmentConsigli];*/
    
    ProdottiArray = [[NSMutableArray alloc] init];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void) loadProducts{
    @try {
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlProdotti]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
    }
    @catch (NSException *exception) {
        //NSLog(@"No connect");
    }

}

- (void)dropViewDidBeginRefreshing{
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
    return [ProdottiArray count];
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
            if (isConsigliato) {
                prod.myCodeValue = [[prodotti objectAtIndex:i] objectForKey:@"PrivateCodeValue"];
                prod.codice = [[prodotti objectAtIndex:i] objectForKey:@"PrivateCode"];
            }
            [ProdottiArray  addObject:prod];
        }
        @catch (NSException *exception) {
            if(x==0){
                [[[TTAlertView alloc] initWithTitle:@"Nessun prodotto!"
                                            message:@"Fatti Consigliare!"
                                           delegate:self
                                  cancelButtonTitle:@"Continua"
                                  otherButtonTitles:nil]
                 show];
                x=1;
            }
        }
        
    }
    // crea la lista filtrata, inizializzandola con il numero di elementi dell'array "lista"
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
    float sconto;
    if (isConsigliato) {
        sconto = [pro.myCodeValue floatValue];
    }
    else{
        sconto = [pro.privateCodeValue floatValue];
    }
    
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
    
    if (isConsigliato) {
        UILabel *privateValue = [[UILabel alloc] initWithFrame:CGRectMake(80, 50, 200, 30)];
        privateValue.font = [UIFont fontWithName:@"Helvetica" size:15];
        privateValue.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        float val = [pro.myCodeValue floatValue];
        pro.oldprezzo = [numberString stringByAppendingString:@" €"];
        val = val *100;
        int myInt = (int) val;
        NSString *privateValueString = [[NSString alloc] initWithFormat:@"%d",myInt];
        privateValueString = [privateValueString stringByAppendingString:@" % di Sconto"];
        privateValue.text = privateValueString;
        
        [cell.contentView addSubview:privateValue];
    }
    else{
        pro.oldprezzo = [numberString stringByAppendingString:@" €"];
    }
    
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
}

-(void)pressedLeftButton
{
    //NSLog(@"Account");
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
        [ProdottiArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
    //UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    //CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    
    
    //UIView *consigliatomiView = [[UIView alloc] initWithFrame:CGRectMake(160, 0, 160, 30)];
    //UIView *consigliatoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
    
    UIButton *consigliatomi = [[UIButton alloc] initWithFrame:CGRectMake(160, 0, 160, 30)];
    UIButton *consigliato = [UIButton buttonWithType:UIButtonTypeCustom];
    [consigliato setTitle:@"Ho consigliato" forState:UIControlStateNormal];
    [consigliato setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    consigliato.frame = CGRectMake(0, 0, 160, 30);
    [consigliatomi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    consigliato.titleLabel.textColor = [UIColor lightGrayColor];
    [consigliato addTarget:self action:@selector(consigliati) forControlEvents:UIControlEventTouchUpInside];
    
    if (isConsigliato) {
        //consigliatoView.backgroundColor = [UIColor whiteColor];
        consigliato.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:14];
        consigliatomi.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        //consigliatomiView.backgroundColor = [UIColor colorWithRed:0/255.0f green:104/255.0f blue:164/255.0f alpha:0.8f];
        
    }
    else{
        //consigliatoView.backgroundColor = [UIColor colorWithRed:0/255.0f green:104/255.0f blue:164/255.0f alpha:0.8f];
        consigliatomi.titleLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:14];
        consigliato.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        //consigliatomiView.backgroundColor = [UIColor whiteColor];
        //[consigliatomi setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    [consigliatomi setTitle:@"Mi hanno consigliato" forState:UIControlStateNormal];
    [consigliatomi addTarget:self action:@selector(consigliatomi) forControlEvents:UIControlEventTouchUpInside];
    
    headerView.backgroundColor = [UIColor colorWithRed:0/255.0f green:104/255.0f blue:164/255.0f alpha:0.8f];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(160, 2, 1, 26)];
    lineView.backgroundColor = [UIColor whiteColor];
    //[headerView addSubview:lineView];
    //[consigliatoView addSubview:consigliato];
    //[consigliatomiView addSubview:consigliatomi];
    [headerView addSubview:consigliato];
    [headerView addSubview:consigliatomi];
    [headerView addSubview:lineView];
    
    return headerView;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return  30.0;
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
    detailViewController = [[ProductsView alloc] initWithNibName:@"ProductsView" bundle:nil];
    detailViewController.isProfilo = @"YES";
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.prod = [ProdottiArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)consigliati{
    //NSLog(@"CONSIGLIATO");
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    isConsigliato = true;
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    self.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_user_prod.php?user=%@", WEBSERVICEURL,valUser ];
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

- (void)consigliatomi{
    //NSLog(@"MI HANNO CONSIGLIATO");
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    isConsigliato = false;
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    self.urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_raccomanded_products.php?user=%@", WEBSERVICEURL,valUser ];
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

- (void) pushProduct{
    [self consigliatomi];
    detailViewController = [[ProductsView alloc] initWithNibName:@"ProductsView" bundle:nil];
    detailViewController.isProfilo = @"YES";
    detailViewController.prod = [ProdottiArray objectAtIndex:0];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Profile View"];
}

@end
