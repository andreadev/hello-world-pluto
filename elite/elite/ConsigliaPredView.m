//
//  ConsigliaPredView.m
//  elite
//
//  Created by Andrea Barbieri on 29/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ConsigliaPredView.h"
#import "User.h"
#import "PreferitiView.h"
#import "AppDelegate.h"
#import "SelectViewController.h"
#import "TTAlertView.h"
#import "GAI.h"

@interface ConsigliaPredView (){
    NSMutableArray *AmiciArray;
    NSMutableDictionary *postParams;
    NSString *selezionati;
    UIActivityIndicatorView *activityIndicator;
}

@end

@implementation ConsigliaPredView
@synthesize preferiti,idprodotto,prod;

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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Consiglia" style:UIBarButtonItemStylePlain target:self action:@selector(pressedRight:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    AmiciArray = [[NSMutableArray alloc] init];
    selezionati = [[NSString alloc] init];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
    [self navigationItem].leftBarButtonItem = barButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void) viewWillAppear:(BOOL)animated{
    [AmiciArray removeAllObjects];
    [self loadPreferiti];
}

- (void) loadPreferiti{
    
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    
    NSString *urlPref = [[NSString alloc] initWithFormat:@"%@Preferiti/get_preferiti.php?user=%@",WEBSERVICEURL, valUser];
    NSLog(@"%@",urlPref);
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPref] error:&error];
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlPref] options:NSDataReadingUncached error:&error];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
}


- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.preferiti = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    NSLog(@"%d", [preferiti count]);
    
    [self loadPrefer];
    
    
    
    
}

- (void) loadPrefer{
    int x=0;
    for (int i = 0; i<[preferiti count]; i++) {
        @try {
            // do something that might throw an exception
            User *amico = [[User alloc] init];
            amico.name = [[preferiti objectAtIndex:i] objectForKey:@"name_f"];
            amico.idfacebook = [[preferiti objectAtIndex:i] objectForKey:@"id_facebook"];
            amico.idelite = [[preferiti objectAtIndex:i] objectForKey:@"id_f"];
            NSLog(@"ID AMICO---> %@",amico.idelite);
            amico.selected = @"0";
            [AmiciArray  addObject:amico];
        }
        @catch (NSException *exception) {
            // deal with the exception
            //NSLog(@"eccezione");
            if (x==0){
                //alert
                TTAlertView *alert =[[TTAlertView alloc] initWithTitle:@"Preferiti" message:@"Non hai nessun preferito" delegate:self cancelButtonTitle:@"Continua" otherButtonTitles:nil];
                [alert show];
                
                x=1;
            }
        }
        
    }
    [self.tableView reloadData];
}


- (IBAction)pressedRight:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    
    NSLog(@"consiglio");
    NSString *valUserID = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    NSLog(@"USERNAME: %@",valUser);
    
    NSString *ima = [[NSString alloc] initWithFormat:@"%@product_images/%@.jpg",WEBSERVICEURL, prod.idprodotto ];
    //ima = [[NSString alloc] initWithFormat:@]
    
    NSString *slogan = [[NSString alloc] initWithFormat:@"Ho appena consigliato: %@ su Elite.",prod.name ];
    
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.eliteadvice.it", @"link",
     ima, @"picture",
     slogan, @"name",
     @"Il social Network che ti fa risparmiare.", @"caption",
     @"Scopri Elite Advice e risparmia su ogni acquisto.", @"description",
     nil];
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              prod.idprodotto,@"id",
                              prod.name, @"name",
                              prod.where, @"store_id",
                              prod.prezzo, @"price",
                              prod.categoria, @"category_id",
                              prod.urlfoto, @"imageurl",
                              valUser,@"username",
                              valUserID,@"userID",
                              prod.desc,@"desc",
                              selezionati,@"ids",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urluploadprod = [[NSString alloc] initWithFormat:@"%@Prodotti/create_product_racco.php", WEBSERVICEURL ];
    [request setURL:[NSURL URLWithString:urluploadprod]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //NSURLResponse *response;
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    //NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
        
        [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
        NSString *alertText = @"Hai consigliato correttamente \n il tuo prodotto";
        [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                    message:alertText
                                   delegate:self
                          cancelButtonTitle:@"Continua"
                          otherButtonTitles:nil]
         show];
        
    }];
    //NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //NSLog(@"Reply: %@", theReply);
    
    /*[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
    NSString *alertText = @"Hai consigliato correttamente \n il tuo prodotto";
    [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                message:alertText
                               delegate:self
                      cancelButtonTitle:@"Continua"
                      otherButtonTitles:nil]
     show];*/
    /*
    if ([[FBSession activeSession]isOpen]) {
     
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
    }*/
    
}


/*
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
         
         [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
         [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"Continua"
                           otherButtonTitles:nil]
          show];
         
     }];
}
*/

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
    return [AmiciArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    User *amico = [AmiciArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = amico.name;
    cell.detailTextLabel.text = amico.idfacebook;
    if([amico.selected isEqualToString:@"0"]){
        cell.imageView.image = [UIImage imageNamed:@"bollas"];
    }
    else{
        cell.imageView.image = [UIImage imageNamed:@"bollasok"];
    }
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

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"esco alert");
    //[self.navigationController popToRootViewControllerAnimated:YES];
    if([alertView.titleLabel.text isEqualToString:@"Preferiti"]){
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate presentHomeController];
    }
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    User *amico = [AmiciArray objectAtIndex:indexPath.row];
    if([amico.selected isEqualToString:@"0"]){
        NSLog(@"%@",@"asd");
        amico.selected = @"1";
        selezionati =  [selezionati stringByAppendingString:@","];
        selezionati = [selezionati stringByAppendingString:amico.idelite];
        
        NSLog(@"%@",selezionati);
    }
    else{
        NSString *idamico = [amico.idelite stringByAppendingString:@","];
        selezionati = [selezionati stringByReplacingOccurrencesOfString:idamico withString:@""];
        amico.selected = @"0";
        NSLog(@"id --->%@",idamico);
        NSLog(@"%@",selezionati);
    }
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Load Detail Racco"];
}

@end
