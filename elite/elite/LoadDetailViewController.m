//
//  LoadDetailViewController.m
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "LoadDetailViewController.h"
#import "AppDelegate.h"
#import "Prodotto.h"
#import "GAI.h"

@interface LoadDetailViewController (){
    NSMutableArray *list;
    NSMutableArray *listLoad;
    JGProgressView *p;
    NSString *filenames;
    NSMutableDictionary *postParams;
    NSString *lat,*lon;
    NSMutableArray *categorie;
    NSString *whereload;
    int category_id;
    int doit;
    LocalizeViewController *location;
    ConsigliaPredView *consigliaPref;
    CategoryView *categoryView;
    UINavigationController *navCategory;
    UINavigationController *navLoc;
    NSString *idProdotto;
    BOOL settedCategory;
    BOOL settedShop;
    BOOL settedName;
    BOOL settedPrice;
    BOOL settedDesc;
    int imageUploading;
    NSString *ima;
    
}

@end

@implementation LoadDetailViewController
@synthesize tabellaView,imageProd,imageViewProd,name,price,where,category,desc,consiglia,consigliaTutti,negozio,locationManager,categoriaid,categorianome,negozioid,negozionome;

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
    imageUploading = 0;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    negozionome = @"Scegli Negozio";
    categorianome = @"Scegli Categoria";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStylePlain target:self action:@selector(pressedDone)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    location = [[LocalizeViewController alloc] initWithNibName:@"LocalizeViewController" bundle:nil];
    navLoc = [[UINavigationController alloc] initWithRootViewController:location];
    [navLoc.navigationBar setTintColor:[UIColor whiteColor]];
    
    categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    navCategory = [[UINavigationController alloc] initWithRootViewController:categoryView];
    [navCategory.navigationBar setTintColor:[UIColor whiteColor]];
    
    consigliaPref = [[ConsigliaPredView alloc] initWithNibName:@"ConsigliaPredView" bundle:nil];
    
    doit = 0;
    // Do any additional setup after loading the view from its nib.    
    CGRect tbFrame = [tabellaView frame];
    tbFrame.size.height = 500;
    [tabellaView setFrame:tbFrame];
    [tabellaView setScrollEnabled:NO];
    
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consiglianew"] forState:UIControlStateNormal];
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
    
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaapreferitinew"] forState:UIControlStateNormal];
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaapreferitipapress"] forState:UIControlStateHighlighted];
    
    list = [[NSMutableArray alloc] initWithObjects:@"Nome",@"Categoria",@"Negozio",@"Descrizione", nil];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    
}


- (void) viewWillAppear:(BOOL)animated{
    /*if(location.shopSelected.nome != nil){
        
        [list replaceObjectAtIndex:2 withObject:location.shopSelected.nome];
    }*/
    self.navigationItem.hidesBackButton = YES;
    
    if((imageProd != nil)&&(imageUploading == 0)){
        [self loadImage];
    }
    [self.tabellaView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.trackedViewName = @"Insert Detail Screen";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


- (void) loadImage{
    [locationManager startUpdatingLocation];
    [[ALAlertBannerManager sharedManager] showAlertBannerInView:self.view
                                                          style:ALAlertBannerStyleNotify
                                                       position:ALAlertBannerPositionTop
                                                          title:@"Caricamento foto in corso!Compila i campi!"
                                                       subtitle:Nil];
    [[ALAlertBannerManager sharedManager] setSecondsToShow:5];
    [[ALAlertBannerManager sharedManager] allowTapToDismiss];
    [consiglia setUserInteractionEnabled:NO];
    [consigliaTutti setUserInteractionEnabled:NO];
    //[consiglia setEnabled:NO];
    //[consigliaTutti setEnabled:NO];
    
    imageUploading = 1;
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //Carico l'immagine, creo il la tupla del prodotto, ritorna l'id
    NSLog(@"CARICO IMMAGINE ");
    NSData *imageDatas = UIImageJPEGRepresentation(imageProd,0.4);     //change Image to NSData
    //NSString *ima = [@"temp_ios" stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if (imageDatas != nil)
    {
        filenames = @"temp_ios";
        NSString *urlString = [[NSString alloc] initWithFormat:@"%@Prodotti/upload_image.php", WEBSERVICEURL ];
        NSMutableURLRequest *requestimage = [[NSMutableURLRequest alloc] init];
        [requestimage setURL:[NSURL URLWithString:urlString]];
        [requestimage setHTTPMethod:@"POST"];
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [requestimage addValue:contentType forHTTPHeaderField: @"Content-Type"];
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[filenames dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file\"; filename=\"provav.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageDatas]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        // setting the body of the post to the reqeust
        [requestimage setHTTPBody:body];
        // now lets make the connection to the web
        
            
        NSData *returnData = [NSURLConnection sendSynchronousRequest:requestimage returningResponse:nil error:nil];
        idProdotto = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"ID PRODOTTO %@", idProdotto);
        imageUploading = 0;
        imageProd = nil;
        [[ALAlertBannerManager sharedManager] showAlertBannerInView:self.view
                                                              style:ALAlertBannerStyleNotify
                                                           position:ALAlertBannerPositionTop
                                                              title:@"Immagine caricata correttamente!"
                                                           subtitle:Nil];
        [[ALAlertBannerManager sharedManager] setSecondsToShow:3];
        [[ALAlertBannerManager sharedManager] allowTapToDismiss];
        [consiglia setUserInteractionEnabled:YES];
        [consigliaTutti setUserInteractionEnabled:YES];
    }
    });
    
    
    
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
    //cell.textLabel.text = [list objectAtIndex:indexPath.row];
    //cell.detailTextLabel.text = [listLoad objectAtIndex:indexPath.row];
    float currentVersion = 6.0;
    
    
    if (doit == 0){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] <= currentVersion)
        {
            NSLog(@"Running in IOS-6");
            
            if(indexPath.row == 0){
                
                
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                
                name = [[UITextField alloc]initWithFrame:CGRectMake(35, 10, 110, 30)];
                name.font = [UIFont fontWithName:@"Helvetica" size:18];
                name.textColor = [UIColor blackColor];
                name.backgroundColor = [UIColor clearColor];
                name.delegate =self;
                name.highlighted = YES;
                name.placeholder = [list objectAtIndex:indexPath.row];
                name.keyboardType = UIKeyboardTypeDefault;
                name.returnKeyType = UIReturnKeyDone;
                name.tag = 0;
                [cell.contentView addSubview:name];
                
                UIImageView *bollaprice = [[UIImageView alloc] initWithFrame:CGRectMake(160, 14, 13 , 13)];
                bollaprice.image = [UIImage imageNamed:@"bollavuota"];
                [cell.contentView addSubview:bollaprice];
                
                price = [[UITextField alloc]initWithFrame:CGRectMake(185, 10, 110, 30)];
                price.font = [UIFont fontWithName:@"Helvetica" size:18];
                price.textColor = [UIColor blackColor];
                price.backgroundColor = [UIColor clearColor];
                price.delegate =self;
                price.highlighted = YES;
                price.placeholder = @"Prezzo";
                price.keyboardType = UIKeyboardTypeDefault;
                price.returnKeyType = UIReturnKeyDone;
                price.tag = 1;
                [cell.contentView addSubview:price];
                
                UILabel *euro = [[UILabel alloc]initWithFrame:CGRectMake(270, 5, 110, 30)];
                euro.font = [UIFont fontWithName:@"Helvetica" size:18];
                euro.textColor = [UIColor lightGrayColor];
                euro.backgroundColor = [UIColor clearColor];
                euro.highlighted = YES;
                euro.text = @"€";
                [cell.contentView addSubview:euro];
            }
            else if(indexPath.row == 1){
                
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
                cell.textLabel.text = categorianome;
                //cell.textLabel.text = [list objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 2){
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
                cell.textLabel.text = negozionome;
                //cell.textLabel.text = [list objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 3){
                NSLog(@"tre");
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                desc = [[UITextField alloc]initWithFrame:CGRectMake(35, 10, 200, 30)];
                desc.font = [UIFont fontWithName:@"Helvetica" size:18];
                desc.textColor = [UIColor blackColor];
                desc.backgroundColor = [UIColor clearColor];
                desc.delegate =self;
                desc.highlighted = YES;
                desc.placeholder = [list objectAtIndex:indexPath.row];
                desc.keyboardType = UIKeyboardTypeDefault;
                desc.returnKeyType = UIReturnKeyDone;
                desc.tag = 2;
                [cell.contentView addSubview:desc];
                doit=1;
            }
        }
        else{
            
            if(indexPath.row == 0){
                
                
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                
                name = [[UITextField alloc]initWithFrame:CGRectMake(45, 5, 110, 30)];
                name.font = [UIFont fontWithName:@"Helvetica" size:18];
                name.textColor = [UIColor blackColor];
                name.backgroundColor = [UIColor clearColor];
                name.delegate =self;
                name.highlighted = YES;
                name.placeholder = [list objectAtIndex:indexPath.row];
                name.keyboardType = UIKeyboardTypeDefault;
                name.returnKeyType = UIReturnKeyDone;
                name.tag = 0;
                [cell.contentView addSubview:name];
                
                price = [[UITextField alloc]initWithFrame:CGRectMake(185, 5, 110, 30)];
                price.font = [UIFont fontWithName:@"Helvetica" size:18];
                price.textColor = [UIColor blackColor];
                price.backgroundColor = [UIColor clearColor];
                price.delegate =self;
                price.highlighted = YES;
                price.placeholder = @"Prezzo";
                price.keyboardType = UIKeyboardTypeDefault;
                price.returnKeyType = UIReturnKeyDone;
                price.tag = 1;
                [cell.contentView addSubview:price];
                
                UIImageView *bollaprice = [[UIImageView alloc] initWithFrame:CGRectMake(160, 14, 13, 13)];
                bollaprice.image = [UIImage imageNamed:@"bollavuota"];
                [cell.contentView addSubview:bollaprice];
                
                UILabel *euro = [[UILabel alloc]initWithFrame:CGRectMake(270, 5, 110, 30)];
                euro.font = [UIFont fontWithName:@"Helvetica" size:18];
                euro.textColor = [UIColor lightGrayColor];
                euro.backgroundColor = [UIColor clearColor];
                euro.highlighted = YES;
                euro.text = @"€";
                [cell.contentView addSubview:euro];
            }
            else if(indexPath.row == 1){
                
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
                cell.textLabel.text = categorianome;
                //cell.textLabel.text = [list objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 2){
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                cell.textLabel.textColor = [UIColor lightGrayColor];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
                cell.textLabel.text = negozionome;
                //cell.textLabel.text = [list objectAtIndex:indexPath.row];
            }
            else if(indexPath.row == 3){
                NSLog(@"tre");
                cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
                desc = [[UITextField alloc]initWithFrame:CGRectMake(45, 5, 200, 30)];
                desc.font = [UIFont fontWithName:@"Helvetica" size:18];
                desc.textColor = [UIColor blackColor];
                desc.backgroundColor = [UIColor clearColor];
                desc.delegate =self;
                desc.highlighted = YES;
                desc.placeholder = [list objectAtIndex:indexPath.row];
                desc.keyboardType = UIKeyboardTypeDefault;
                desc.returnKeyType = UIReturnKeyDone;
                desc.tag = 2;
                [cell.contentView addSubview:desc];
                doit=1;
            }
            
            
        }
        
        
    /*else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
        
        price = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 120, 30)];
        price.font = [UIFont fontWithName:@"Helvetica" size:18];
        price.textColor = [UIColor blackColor];
        price.backgroundColor = [UIColor clearColor];
        price.delegate =self;
        price.highlighted = YES;
        price.placeholder = [list objectAtIndex:indexPath.row];
        price.keyboardType = UIKeyboardTypeDefault;
        price.returnKeyType = UIReturnKeyDone;
        price.secureTextEntry = YES;
        [cell.contentView addSubview:price];
        
    }*//*
    else if(indexPath.row == 1){
        cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
        
        cell.textLabel.text = [list objectAtIndex:indexPath.row];
        where = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
        where.font = [UIFont fontWithName:@"Helvetica" size:18];
        where.textColor = [UIColor blackColor];
        where.backgroundColor = [UIColor clearColor];
        where.delegate =self;
        where.highlighted = YES;
        where.placeholder = [list objectAtIndex:indexPath.row];
        where.keyboardType = UIKeyboardTypeDefault;
        where.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:where];

    }
    else if(indexPath.row == 2){
        cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
        cell.textLabel.text = [list objectAtIndex:indexPath.row];
        category = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
        category.font = [UIFont fontWithName:@"Helvetica" size:18];
        category.textColor = [UIColor blackColor];
        category.backgroundColor = [UIColor clearColor];
        category.delegate =self;
        category.highlighted = YES;
        category.placeholder = [list objectAtIndex:indexPath.row];
        category.keyboardType = UIKeyboardTypeDefault;
        category.returnKeyType = UIReturnKeyDone;
        [cell.contentView addSubview:category];
    }*/
    
    }
    else{
        if (indexPath.row == 0) {
            if (settedName == YES) {
            //cell.imageView.image = [UIImage imageNamed:@"bollasok"];
            }
        }
        else if(indexPath.row == 1){
            if (![categorianome isEqualToString:@"Negozio"]){
                //cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.text = categorianome;
            }
        }
        else if(indexPath.row == 2){
            if (location.shopSelected != nil){
                //cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.text = negozionome;
            }
        }
        else if(indexPath.row == 3){
            NSLog(@"sono al tre");
            if (settedDesc == YES) {
                //cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                NSLog(@"sono al tre");
            }
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
    //cell.textLabel.textColor = [UIColor blackGrayColor];
    //cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    //cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
    //cell.detailTextLabel.textColor = [UIColor lightGrayColor];

    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        [name resignFirstResponder];
        [price resignFirstResponder];
        [desc resignFirstResponder];
        /*[UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown
                               forView:categoryPicker
                                 cache:YES];
        [[self view] addSubview:categoryPicker];
        [UIView commitAnimations];*/
        //[self.view addSubview:categoryPicker];
        //categoryPicker.frame = CGRectMake(0, 440, 320, 20);
 // somewhere offscreen, in the direction you want it to appear from
        /*[UIView animateWithDuration:0.5
                         animations:^{
                             categoryPicker.frame = CGRectMake(0, 205, 320, 20);
 // its final location
                         }];*/
        //[self.view addSubview:categoryPicker];
        categoryView.loadDetail = self;
         [self presentViewController:navCategory animated:YES completion:NO];
        
    }
    if (indexPath.row == 2) {
        
        //categoryPicker.frame = CGRectMake(0, 205, 320, 20);
        // somewhere offscreen, in the direction you want it to appear from
        /*[UIView animateWithDuration:0.5
                         animations:^{
                             categoryPicker.frame =CGRectMake(0, 440, 320, 20);
                             // its final location
                         }];
        [categoryPicker removeFromSuperview];*/
        [name resignFirstResponder];
        [price resignFirstResponder];
        [desc resignFirstResponder];
        
        location.latitudine = lat;
        location.longitudine = lon;
        //location.loadDetail = self;
        
        location.loadDetail = self;
        [self presentViewController:navLoc animated:YES completion:NO];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)viewDidUnload {
    [self setTabellaView:nil];
    [self setImageViewProd:nil];
    [self setConsiglia:nil];
    [self setConsigliaTutti:nil];
    [super viewDidUnload];
}
- (IBAction)seeConsiglia:(id)sender {
    
    if ([self isValid]) {
    //UPLOAD IMMAGINE
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    //[self.view addSubview:p];
    //p.animationSpeed = 1.0;
    //[p setIndeterminate:YES];
    
    NSString *valUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
     NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    NSLog(@"USERNAME: %@",valUser);
    
    ima = [[NSString alloc] initWithFormat:@"%@product_images/%@.jpg",WEBSERVICEURL, idProdotto ];
    //ima = [[NSString alloc] initWithFormat:@]
    
    NSString *slogan = [[NSString alloc] initWithFormat:@"Ho appena consigliato: %@ su Elite.",name.text ];
    
    
    postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.eliteadvice.it", @"link",
     ima, @"picture",
     slogan, @"name",
     @"Il social Network che ti fa risparmiare.", @"caption",
     @"Scopri Elite Advice e risparmia su ogni acquisto.", @"description",
     nil];
    
    
    //NSLog(@"%@,%@,%@,%@,%@,%@,", name.text,where.text,price.text,cat,ima,desc.text);

    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              idProdotto,@"id",
                              name.text, @"name",
                              negozioid, @"store_id",
                              price.text, @"price",
                              categoriaid, @"category_id",
                              ima, @"imageurl",
                              valUser,@"username",
                              valUserID,@"userID",
                              desc.text,@"desc",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urluploadprod = [[NSString alloc] initWithFormat:@"%@Prodotti/create_product.php", WEBSERVICEURL ];
    [request setURL:[NSURL URLWithString:urluploadprod]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    
    if ([[FBSession activeSession]isOpen]) {
        /*
         * if the current session has no publish permission we need to reauthorize
         */
        if ([[[FBSession activeSession]permissions]indexOfObject:@"publish_actions"] == NSNotFound) {
            NSLog(@"sessione non aperta");
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                               defaultAudience:FBSessionDefaultAudienceFriends
                                                  allowLoginUI:YES
                                             completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                                 if (!error && status == FBSessionStateOpen) {
                                                     [self publishStory];
                                                 }else{
                                                     NSLog(@"error");
                                                 }
                                             }];
            
        }else{
            NSLog(@"sessione aperta");
            [self publishStory];
        }
    }else{
        /*
         * open a new session with publish permission
         */
        NSLog(@"sessione riaperta");
        [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObject:@"publish_actions"]
                                           defaultAudience:FBSessionDefaultAudienceFriends
                                              allowLoginUI:YES
                                         completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                             if (!error && status == FBSessionStateOpen) {
                                                 [self publishStory];
                                             }else{
                                                 NSLog(@"error");
                                             }
                                         }];
    }
    }
    else{
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"Compila tutti i campi prima di consigliare"
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
    }
    

}



- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:postParams
     HTTPMethod:@"POST"
     completionHandler:^(FBRequestConnection *connection,
                         id result,
                         NSError *error) {
         NSString *alertText;
         if (error) {
             alertText = [NSString stringWithFormat:
                          @"error: domain = %@, code = %d",
                          error.domain, error.code];
         } else {
             alertText = @"Hai consigliato correttamente \n il tuo prodotto";
         }
         // Show the result in an alert
         [self pulisci];
         [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
         
         [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"Continua"
                           otherButtonTitles:nil]
          show];
         //[p removeFromSuperview];
         
     }];
}


- (void) pulisci{
    name.text = @"";
    price.text = @"";
    desc.text = @"";
    negozionome = @"Scegli Negozio";
    categorianome = @"Scegli Categoria";
    imageProd = nil;
    
    [self reloadTabella];
}

- (IBAction)seeConsigliaPreferiti:(id)sender {
    if ([self isValid]) {
        Prodotto *prod = [[Prodotto alloc] init];
        prod.idprodotto = idProdotto;
        prod.name = name.text;
        prod.where = negozioid;
        prod.prezzo = price.text;
        prod.categoria = categoriaid;
        prod.urlfoto = [[NSString alloc] initWithFormat:@"%@product_images/%@.jpg",WEBSERVICEURL, idProdotto ];
        prod.desc = desc.text;
        consigliaPref.prod = prod;
        [self pulisci];
        [self.navigationController pushViewController:consigliaPref animated:YES];
    }
    else{
        [[[TTAlertView alloc] initWithTitle:@"Ops..."
                                    message:@"Compila tutti i campi prima di consigliare"
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil
          ]
         show];
    }
    
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location");
    
    lat =[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    
    lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    [locationManager stopUpdatingLocation];
}


- (void) reloadTabella{
    NSLog(@"ricarico");
    [self.tabellaView reloadData];
}

- (void) pressedDone{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"esco alert");
    if([alertView.titleLabel.text isEqualToString:@"Ops..."]){
        
    }
    else{
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate presentHomeController];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (Boolean) isValid{
    
    if ([name.text isEqualToString:@""] || location.shopSelected == nil || [price.text isEqualToString:@""]  || [categorianome isEqualToString:@"Negozio"]) {
        return false;
    }
    
    return true;
}

@end
