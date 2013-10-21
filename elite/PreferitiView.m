//
//  PreferitiView.m
//  elite
//
//  Created by Andrea Barbieri on 05/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "PreferitiView.h"
#import "FBFriend.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "GAI.h"

@interface PreferitiView (){
    NSArray *friends;
    FBFriendPickerViewController *friendPickerController;
    NSMutableArray *amici;
    NSMutableDictionary *postPara;
    NSString *idialog;
    NSMutableArray *friendNumber;
    NSArray *indexed;
    NSMutableArray *nomicognomi;

}

@end

@implementation PreferitiView
@synthesize session,itemCell;

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
    
    [self populateUserDetails];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"Friendlist"]==NO){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Friendlist"];
        [self getFriendsFirst];
    }
    else{
        [self getFriends];
    }
    
    amici = [[NSMutableArray alloc] init];
    friendNumber = [[NSMutableArray alloc] init];
    nomicognomi = [NSMutableArray arrayWithObjects:
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   [NSMutableArray array],
                   nil];
    indexed = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    
    
}

- (void) viewWillAppear:(BOOL)animated{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)getFriendsFirst{
    NSLog(@"GET FRIEND FIRST");
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    FBAccessTokenData *tokenData = [[FBSession activeSession] accessTokenData];
    NSLog(@" TOKEN %@", tokenData.accessToken);
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    NSString *url = [[NSString alloc] initWithFormat:@"%@Preferiti/friendlist_first.php?user=%@&acc=%@", WEBSERVICEURL,valUser ,tokenData.accessToken ];
    NSLog(@"%@",url);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do something...
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            [[[TTAlertView alloc] initWithTitle:@"Segui i tuoi amici!"
                                        message:@"Vuoi seguire i tuoi amici?"
                                       delegate:self
                              cancelButtonTitle:@"Si"
                              otherButtonTitles:@"Non ora",nil
              ]
             show];
            
        });
    });
}

- (void)removeFriend{
    NSLog(@"REMOVE FRIEND");
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    FBAccessTokenData *tokenData = [[FBSession activeSession] accessTokenData];
    NSLog(@" TOKEN %@", tokenData.accessToken);
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    NSString *url = [[NSString alloc] initWithFormat:@"%@Preferiti/remove_all.php?user=%@", WEBSERVICEURL,valUser ];
    NSLog(@"%@",url);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do something...
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            
        });
    });
}

- (void)getFriends{
    NSLog(@"GET FRIEND");
    [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    FBAccessTokenData *tokenData = [[FBSession activeSession] accessTokenData];
    NSLog(@" TOKEN %@", tokenData.accessToken);
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    NSString *url = [[NSString alloc] initWithFormat:@"%@Preferiti/friendlist.php?user=%@&acc=%@", WEBSERVICEURL,valUser ,tokenData.accessToken ];
    NSLog(@"%@",url);
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Do something...
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        });
    });
    /*
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
     //[self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
     [self performSelectorInBackground:@selector(fetchedData:) withObject:data];
     
     });*/
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //self.title = user.name;
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
                 
                 
                 
                 
             }
         }];
    }
}

- (void)fetchedData:(NSData *)responseData {
    
    
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    friends = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadFriends];
    [self.tableView reloadData];
    
    
}

- (void) loadFriends{
    
    NSLog(@"%d",[friends count]);
    if ([friends count] == 0)
        [self getFriends];
    else{
        for (int i = 0; i<[friends count]; i++) {
        
            FBFriend *fb = [[FBFriend alloc] init];
            fb.hasapp = [[friends objectAtIndex:i] objectForKey:@"hasapp"];
            fb.name = [[friends objectAtIndex:i] objectForKey:@"name"];
            fb.idfb= [[friends objectAtIndex:i] objectForKey:@"id"];
            [amici addObject:fb];
            NSLog(@"%@", fb.name);
            NSLog(@"%@", fb.idfb);
            NSLog(@"%@", fb.hasapp);
            NSString *str =[NSString stringWithFormat:@"%c",[fb.name characterAtIndex:0]];
            for (int j=0; j<[indexed count]; j++){
                NSString *lettera = [indexed objectAtIndex:j];
                if ([lettera isEqualToString:str])  {
                    
                    [nomicognomi[j] addObject:fb];
                }
            }
            //NSLog(@"a");
        }
    
    // crea la lista filtrata, inizializzandola con il numero di elementi dell'array "lista"
	//filteredListContent = [[NSMutableArray alloc] initWithCapacity: [ProdottiArray count]];
	//inserisce in questa  nuova lista gli elementi della lista originale
	//[filteredListContent addObjectsFromArray:ProdottiArray];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [amici count];
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [indexed count];
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [indexed objectAtIndex:section];
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return indexed;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"%d",[nomicognomi[section] count]);
    //return [self numeroRighe:[indexed objectAtIndex:section]];
    return [nomicognomi[section] count];
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FriendCell *cell = (FriendCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        // carichiamo il nib della cella e assegniamolo alla
        [[NSBundle mainBundle] loadNibNamed:@"FriendCell" owner:self options:NULL];
        cell = itemCell;
    }
    // Configure the cell...
    NSString *alph = [indexed objectAtIndex:[indexPath section]];
    //FBFriend *amicofb = [amici objectAtIndex:indexPath.row];
    NSMutableArray *index = [nomicognomi objectAtIndex:indexPath.section];
    FBFriend *amicofb = [index objectAtIndex:indexPath.row];
    
    NSString *str = amicofb.name;
    str =[NSString stringWithFormat:@"%c",[str characterAtIndex:0]];
    NSLog(@"%d", indexPath.row);
    NSLog(@"%@---->%@",alph,str);
    
    //NSString *alphabet = [friendIndex objectAtIndex:[indexPath section]];
    //---get all states beginning with the letter---
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", alphabet];
    
    //NSPredicate *pred = [ NSPredicate predicateWithFormat:@"%c",[amicofb.name characterAtIndex:0]];
        
        if ([str isEqual:alph])  {
            cell.labelNome.text = amicofb.name;
            //cell.detailTextLabel.text = amicofb.idfb;
            NSLog(@"%@",amicofb.idfb);
            NSLog(@"%@",amicofb.hasapp);
            //int hasapp = amicofb.hasapp;
            NSString *hasApp = [[NSString alloc] initWithFormat:@"%@",amicofb.hasapp ];
            //NSLog(hasapp ? @"Yes" : @"No");
            NSLog(@"%@",hasApp);
            if ([hasApp isEqualToString:@"0"]) {
                //INVITA
                NSLog(@"NO APP");
                [cell.follow setTitle:@"" forState:UIControlStateNormal];
                [cell.follow setBackgroundImage:[UIImage imageNamed:@"invitanew"] forState:UIControlStateNormal];
                [cell.follow setTag:amicofb.idfb];
                [cell.follow addTarget:self action:@selector(inviteTo:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if ([hasApp isEqualToString:@"1"]){
                //SEGUI
                NSLog(@"SI APP");
                [cell.follow setTitle:@"" forState:UIControlStateNormal];
                [cell.follow setTag:amicofb.idfb];
                [cell.follow setBackgroundImage:[UIImage imageNamed:@"seguinew"] forState:UIControlStateNormal];
                //[consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
                NSLog(@"%@",amicofb.idfb);
                
                cell.follow.titleLabel.textAlignment = NSTextAlignmentCenter;
                [cell.follow addTarget:self action:@selector(seguiTo:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else if ([hasApp isEqualToString:@"2"]){
                //SEGUI
                NSLog(@"SI APP");
                [cell.follow setTitle:@"" forState:UIControlStateNormal];
                [cell.follow setTag:amicofb.idfb];
                [cell.follow setBackgroundImage:[UIImage imageNamed:@"seguogianew"] forState:UIControlStateNormal];
                //[consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
                NSLog(@"%@",amicofb.idfb);
                
                cell.follow.titleLabel.textAlignment = NSTextAlignmentCenter;
                [cell.follow addTarget:self action:@selector(nonseguiTo:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    
    
    
    
    
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) inviteTo:(id) sender{
    NSLog(@"%d",[sender tag]);
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    NSMutableArray *index = [nomicognomi objectAtIndex:indexPath.section];
    FBFriend *amicofb = [index objectAtIndex:indexPath.row];
    
    //[self share];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   amicofb.idfb, @"to",
                                   @"Scopri Elite Advice",  @"message",
                                   @"Scatta, Consiglia, Risparmia!", @"description",
                                   @"www.eliteadvice.it", @"link",
                                   @"http://www.eliteadvice.it/style/images/home_users.jpg", @"picture",
                                   @"107955302711336",@"app_id",
                                   @"feed",@"method",
                                   @"EliteAdvice.it",@"name",
                                   nil];
    
    [FBSession activeSession];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:session//
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
         NSLog(@"%@",error);
         NSLog(@"%@",resultURL);
         
     }];
    
    
    
}

- (void) nonseguiTo:(id) sender{
    [sender setBackgroundImage:[UIImage imageNamed:@"seguinew"] forState:UIControlStateNormal];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    NSMutableArray *index = [nomicognomi objectAtIndex:indexPath.section];
    FBFriend *amicofb = [index objectAtIndex:indexPath.row];

    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    //NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              valUser, @"id_p",
                              amicofb.idfb, @"id_f",
                              nil];
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlnick = [[NSString alloc] initWithFormat:@"%@Preferiti/remove_preferiti.php", WEBSERVICEURL ];
    
    [request setURL:[NSURL URLWithString:urlnick]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    //NSLog(@"%@",theReply);
    
    if ([theReply rangeOfString:@"Array1"].location == NSNotFound) {
        NSLog(@"Remove NON RIUSCITO");
    } else {
        NSLog(@"Remove LOGIN RIUSCITO");
    }
    
}
- (void) seguiTo:(id) sender{
    //100002916262674
    NSLog(@"%d",[sender tag]);
    NSLog(@"Segui");
    [sender setBackgroundImage:[UIImage imageNamed:@"seguogianew"] forState:UIControlStateNormal];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    NSMutableArray *index = [nomicognomi objectAtIndex:indexPath.section];
    FBFriend *amicofb = [index objectAtIndex:indexPath.row];

    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    //NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              valUser, @"id_p",
                              amicofb.idfb, @"id_f",
                              amicofb.name, @"name_f",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlnick = [[NSString alloc] initWithFormat:@"%@Preferiti/add_preferiti.php", WEBSERVICEURL ];
    
    [request setURL:[NSURL URLWithString:urlnick]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    //NSLog(@"%@",theReply);
    
    if ([theReply rangeOfString:@"Array1"].location == NSNotFound) {
        NSLog(@"ADD NON RIUSCITO");
    } else {
        NSLog(@"ADD LOGIN RIUSCITO");
            
    }
    
}
- (void) share{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   idialog, @"to",
                                   @"Scopri Elite Advice",  @"message",
                                   @"Scatta, Consiglia, Risparmia!", @"description",
                                   @"www.eliteadvice.it", @"link",
                                   @"http://www.eliteadvice.it/style/images/home_users.jpg", @"picture",
                                   @"107955302711336",@"app_id",
                                   @"feed",@"method",
                                   @"EliteAdvice.it",@"name",
                                   nil];
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:session//[FBSession activeSession]
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error){
     }];
    
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            
            
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}

- (void)alertView:(TTAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"esco alert");
    if(buttonIndex == 0){
        
    }
    else if (buttonIndex == 1){
        [self removeFriend];
    }
}


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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Favorites"];
}

@end
