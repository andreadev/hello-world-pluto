//
//  HomeViewController.m
//  elite
//
//  Created by Andrea Barbieri on 22/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "HomeViewController.h"
#import "ProductsView.h"
#import "Prodotto.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchView.h"
#import "AppDelegate.h"
#import "Reachability.h"
#import "GAI.h"

@interface HomeViewController (){
    NSMutableArray *ProdottiArray;
   
    int scopeButtonPressedIndexNumber;
    NSString *url;
    int iol;
    NSString *lat;
    NSString *lon;
}

@end

@implementation HomeViewController
@synthesize prodotti,itemCell,urlProdotti,locationManager,ProdottiArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Home"
                                   image:[UIImage imageNamed:@"53-house"]
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
    //Refresh Control
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"doit"];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    UIImage *menuButtonImage = [UIImage imageNamed:@"cerca"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [btnToggle showsTouchWhenHighlighted];
    iol=0;
    
    lat = @"";
    lon = @"";

    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    
    
    
    self.navigationItem.rightBarButtonItem = menuBarButton;
    ProdottiArray = [[NSMutableArray alloc] init];
    [self.refreshControl beginRefreshing];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Home Screen"];
}

- (void) loadProducts{
    
    @try {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlProdotti]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });

    }
    @catch (NSException *exception) {
        //NSLog (@"No internet connection");
    }
    
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    //NSLog(@"pull");
    prodotti = nil;
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    
    
    if(locationAllowed == NO){
        //NSLog(@"fatto");
        [self.refreshControl endRefreshing];
    }
    else{
        //NSLog(@"localizz");
        [locationManager startUpdatingLocation];
    }
    //[self loadProducts];
}


- (void)fetchedData:(NSData *)responseData {
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.prodotti = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadProdotti];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"doit"];
    //[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    
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


- (void) loadProdotti{
    int x=0;
    for (int i = 0; i<[prodotti count]; i++) {
        @try {
            //NSLog(@"istanzio");
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
            ////NSLog(@"eccezione");
            //PreferitiView *pref = [[PreferitiView alloc] initWithNibName:@"PreferitiView" bundle:nil];
            //[self.navigationController pushViewController:pref animated:YES];
            if(x==0){
            [[[TTAlertView alloc] initWithTitle:@"Nessun prodotto!"
                                        message:@"Consiglia i tuoi prodotti!"
                                       delegate:self
                              cancelButtonTitle:@"Continua"
                              otherButtonTitles:nil]
             show];
                x=1;
            }
        }
        
    }
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

-(void)pressedLeftButton
{
    
    SearchView *search = [[SearchView alloc] initWithNibName:@"SearchView" bundle:nil];
    search.rootController = self;
    search.lat = lat;
    search.lon = lon;
    [self.navigationController pushViewController:search animated:YES];
       
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    lat =[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    [locationManager stopUpdatingLocation];
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    urlProdotti = [[NSString alloc] initWithFormat:@"%@Prodotti/get_last_products_geoloc.php?lat=%@&lng=%@&dist=300&user=%@", WEBSERVICEURL,lat,lon,valUser ];
    //NSLog(@"%@", urlProdotti);
    prodotti = nil;
    
   
    // allocate a reachability object
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    BOOL locationAllowed = [CLLocationManager locationServicesEnabled];
    if(locationAllowed == YES){
        //NSLog(@"localizzazione attivata");
        if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){
            [[ALAlertBannerManager sharedManager] showAlertBannerInView:self.navigationController.view
                                                                  style:ALAlertBannerStyleFailure
                                                               position:ALAlertBannerPositionTop
                                                                  title:@"Abilita servizio localizzazione!"
                                                               subtitle:Nil];
            [[ALAlertBannerManager sharedManager] setSecondsToShow:10];
            [[ALAlertBannerManager sharedManager] allowTapToDismiss];
        }else{
            reach.reachableBlock = ^(Reachability*reach)
            {
                //NSLog(@"REACHABLE!");
                [ProdottiArray removeAllObjects];
                BOOL doit = [[NSUserDefaults standardUserDefaults] boolForKey:@"doit"];
                //NSLog(@"valore %hhd", doit);
                
                if (doit == NO){
                    [self loadProducts];
                    //NSLog(@"load");
                }
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"doit"];
                
                //[MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            };
        }
        reach.unreachableBlock = ^(Reachability*reach)
        {
            //NSLog(@"UNREACHABLE!");
            [self.refreshControl endRefreshing];
            [[ALAlertBannerManager sharedManager] showAlertBannerInView:self.navigationController.view
                                                                  style:ALAlertBannerStyleFailure
                                                               position:ALAlertBannerPositionTop
                                                                  title:@"Connessione ad internet non disponibile!"
                                                               subtitle:Nil];
            [[ALAlertBannerManager sharedManager] setSecondsToShow:10];
            [[ALAlertBannerManager sharedManager] allowTapToDismiss];
            
        };
    }
    else{
        //NSLog(@"Localizzazione disabilitata");
        [self.refreshControl endRefreshing];
        [[ALAlertBannerManager sharedManager] showAlertBannerInView:self.navigationController.view
                                                              style:ALAlertBannerStyleFailure
                                                           position:ALAlertBannerPositionTop
                                                              title:@"Localizzazione disabilitata, attivala!"
                                                           subtitle:Nil];
        [[ALAlertBannerManager sharedManager] setSecondsToShow:10];
        [[ALAlertBannerManager sharedManager] allowTapToDismiss];
    }
    // set the blocks
    
    
    // start the notifier which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    //[locationManager stopUpdatingLocation];
}

-(void)getProdLocalized{
    //NSLog(@"GET PROD");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0,tableView.frame.size.width,30)];
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, headerView.frame.size.width-120.0, headerView.frame.size.height)];
    
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.text = @"Ultimi prodotti consigliati";
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
     //ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
    ProductsView *detailViewController = [[ProductsView alloc] initWithNibName:@"ProductsView" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.prod = [ProdottiArray objectAtIndex:indexPath.row];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)viewDidUnload {
    [self setRedLine:nil];
    [super viewDidUnload];
}



@end
