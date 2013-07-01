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
    int imageUploaded;
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
    imageUploaded = 0;
    [self.navigationItem setHidesBackButton:NO animated:YES];
    negozionome = @"Negozio";
    categorianome = @"Categoria";
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Annulla" style:UIBarButtonItemStylePlain target:self action:@selector(pressedDone)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    location = [[LocalizeViewController alloc] initWithNibName:@"LocalizeViewController" bundle:nil];
    navLoc = [[UINavigationController alloc] initWithRootViewController:location];
    [navLoc.navigationBar setTintColor:[UIColor whiteColor]];
    
    categoryView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    navCategory = [[UINavigationController alloc] initWithRootViewController:categoryView];
    [navLoc.navigationBar setTintColor:[UIColor whiteColor]];
    
    consigliaPref = [[ConsigliaPredView alloc] initWithNibName:@"ConsigliaPredView" bundle:nil];
    
    doit = 0;
    // Do any additional setup after loading the view from its nib.    
    CGRect tbFrame = [tabellaView frame];
    tbFrame.size.height = 500;
    [tabellaView setFrame:tbFrame];
    
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consiglianew"] forState:UIControlStateNormal];
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
    
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaapreferitinew"] forState:UIControlStateNormal];
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaapreferitipapress"] forState:UIControlStateHighlighted];

    
    list = [[NSMutableArray alloc] initWithObjects:@"Nome",@"Categoria",@"Negozio",@"Descrizione", nil];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    
    p = [[JGProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [p setUseSharedImages:YES];
    p.frame = CGRectMake(50, 50, 280, p.frame.size.height);
    p.center = CGPointMake(CGRectGetMidX(self.view.bounds), p.center.y);
    
    
}


- (void) viewWillAppear:(BOOL)animated{
    /*if(location.shopSelected.nome != nil){
        
        [list replaceObjectAtIndex:2 withObject:location.shopSelected.nome];
    }*/
    
    if(imageProd != nil){
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
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //Carico l'immagine, creo il la tupla del prodotto, ritorna l'id
    NSLog(@"CARICO IMMAGINE ");
    NSData *imageDatas = UIImageJPEGRepresentation(imageProd,0.4);     //change Image to NSData
    //NSString *ima = [@"temp_ios" stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if (imageDatas != nil)
    {
        
        //set name here
        //filenames = [NSString stringWithFormat:ima];
        filenames = @"temp_ios";
        NSLog(@"%@", filenames);
        
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
            
            NSLog(@"finish");
            imageUploaded = 1;
            imageProd = nil;
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
    if (doit == 0){
        if(indexPath.row == 0){
            cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
            
            name = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 110, 30)];
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
            
            price = [[UITextField alloc]initWithFrame:CGRectMake(150, 10, 110, 30)];
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
            euro.textColor = [UIColor blackColor];
            euro.backgroundColor = [UIColor clearColor];
            euro.highlighted = YES;
            euro.text = @"€";
            [cell.contentView addSubview:euro];
        }
        else if(indexPath.row == 1){
            cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
            cell.textLabel.text = categorianome;
            //cell.textLabel.text = [list objectAtIndex:indexPath.row];
        }
        else if(indexPath.row == 2){
            cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
            cell.textLabel.text = negozionome;
            //cell.textLabel.text = [list objectAtIndex:indexPath.row];
        }
        else if(indexPath.row == 3){
            NSLog(@"tre");
            cell.imageView.image = [UIImage imageNamed:@"bollavuota"];
            desc = [[UITextField alloc]initWithFrame:CGRectMake(30, 10, 200, 30)];
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
            cell.imageView.image = [UIImage imageNamed:@"bollasok"];
            }
        }
        else if(indexPath.row == 1){
            if (![categorianome isEqualToString:@"Negozio"]){
                cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                cell.textLabel.text = categorianome;
            }
        }
        else if(indexPath.row == 2){
            if (location.shopSelected != nil){
                cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                cell.textLabel.text = negozionome;
            }
        }
        else if(indexPath.row == 3){
            NSLog(@"sono al tre");
            if (settedDesc == YES) {
                cell.imageView.image = [UIImage imageNamed:@"bollasok"];
                NSLog(@"sono al tre");
            }
        }
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
    
    //UPLOAD IMMAGINE
    
    
    
    [self.view addSubview:p];
    p.animationSpeed = 1.0;
    [p setIndeterminate:YES];
    
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
                              negozionome, @"store_id",
                              price.text, @"price",
                              categoriaid, @"category_id",
                              @"Dummy", @"insertion_code",
                              ima, @"imageurl",
                              valUser,@"username",
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
         
         [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"Continua"
                           otherButtonTitles:nil]
          show];
         [p removeFromSuperview];
         
     }];
}


- (void) pulisci{
    
    imageUploaded = 0;
    name.text = @"";
    price.text = @"";
    desc.text = @"";
    categorianome= @"Categoria";
    negozionome = @"Negozio";
    imageProd = nil;
    
    [self reloadTabella];
}

- (IBAction)seeConsigliaPreferiti:(id)sender {
    
    Prodotto *prod = [[Prodotto alloc] init];
    prod.idprodotto = idProdotto;
    prod.name = name.text;
    prod.where = negozionome;
    prod.prezzo = price.text;
    prod.categoria = categoriaid;
    prod.urlfoto = [[NSString alloc] initWithFormat:@"%@product_images/%@.jpg",WEBSERVICEURL, idProdotto ];
    prod.desc = desc.text;
    consigliaPref.prod = prod;
    [self pulisci];
    [self.navigationController pushViewController:consigliaPref animated:YES];
    
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location");
    
    lat =[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    
    lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"finito editing");
    
    if(textField.tag == 0){
        NSLog(@"lol");
        settedName = YES;
        //[self reloadTabella];
        [self performSelectorOnMainThread:@selector(reloadTabella) withObject:nil waitUntilDone:YES];
    }
    else if (textField.tag == 1){
        settedPrice = YES;
       [self reloadTabella];
    }
    else if (textField.tag == 2){
        settedDesc = YES;
        [self reloadTabella];
    }
    [self reloadTabella];
    return YES;
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
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentHomeController];
    
    
}

@end
