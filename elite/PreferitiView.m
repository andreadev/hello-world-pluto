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

@interface PreferitiView (){
    NSArray *friends;
    FBFriendPickerViewController *friendPickerController;
    NSMutableArray *amici;
}

@end

@implementation PreferitiView
@synthesize session,itemCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Preferiti"
                                   image:[UIImage imageNamed:@"29-heart"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateUserDetails];
    [self getFriends];
    UIImage *menuButtonImage = [UIImage imageNamed:@"06-magnify"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    amici = [[NSMutableArray alloc] init];
    
    //self.title = @"Preferiti";
    friendPickerController =
    [[FBFriendPickerViewController alloc] init];
    // Set the friend picker title
    friendPickerController.title = @"Pick Friends";
    friendPickerController.delegate = self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) pressedLeftButton{
    // Initialize the friend picker
    // TODO: Set up the delegate to handle picker callbacks, ex: Done/Cancel button
    
    // Load the friend data
    [friendPickerController loadData];
    // Show the picker modally
    [friendPickerController presentModallyFromViewController:self animated:YES handler:nil];
    
}

/*
 * Event: Error during data fetch
 */
- (void)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                       handleError:(NSError *)error
{
    NSLog(@"Error during data fetch.");
}

/*
 * Event: Data loaded
 */
- (void)friendPickerViewControllerDataDidChange:(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Friend data loaded.");
}

/*
 * Event: Decide if a given user should be displayed
 */
- (BOOL)friendPickerViewController:(FBFriendPickerViewController *)friendPicker
                 shouldIncludeUser:(id <FBGraphUser>)user
{
    // Filtering example: only show users who have
    // "ch" in their names
    NSRange result = [user.name rangeOfString:@"ch"
                                      options:NSCaseInsensitiveSearch];
    if (result.location != NSNotFound) {
        return YES;
    } else {
        return NO;
    }
}


/*
 * Event: Selection changed
 */
- (void)friendPickerViewControllerSelectionDidChange:
(FBFriendPickerViewController *)friendPicker
{
    NSLog(@"Current friend selections: %@", friendPicker.selection);
    NSLog(@"%@",[friendPicker.selection objectAtIndex:0]);
    //NSLog(@"%@",[friendPicker.selection objectAtIndex:1]);
    //NSLog(@"%@",[friendPicker.selection objectAtIndex:2]);
}

/*
 * Event: Done button clicked
 */
- (void)facebookViewControllerDoneWasPressed:(id)sender {
    FBFriendPickerViewController *friendPickerControllera =
    (FBFriendPickerViewController*)sender;
    NSLog(@"Selected friends: %@", friendPickerControllera.selection);
    // Dismiss the friend picker
    
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
}

/*
 * Event: Cancel button clicked
 */
- (void)facebookViewControllerCancelWasPressed:(id)sender {
    NSLog(@"Canceled");
    // Dismiss the friend picker
    [[sender presentingViewController] dismissModalViewControllerAnimated:YES];
}


- (void)getFriends{
    FBAccessTokenData *tokenData = [[FBSession activeSession] accessTokenData];
    NSLog(@" TOKEN %@", tokenData.accessToken);
    
    NSString *url = [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/Preferiti/friendlist.php?acc=%@",tokenData.accessToken ];
    NSLog(@"%@",url);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
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
    NSLog(@"qui ci sono");
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [amici count];
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
    FBFriend *amicofb = [amici objectAtIndex:indexPath.row];
    
    cell.labelNome.text = amicofb.name;
    //cell.detailTextLabel.text = amicofb.idfb;
    NSLog(@"%@",amicofb.idfb);
    NSString *hasapp = amicofb.hasapp;
    NSString *fal = @"false";
    
    if (![fal isEqualToString:hasapp]) {
        NSLog(@"NO APP");
        cell.follow.titleLabel.text = @"INVITA";
        [cell.follow addTarget:self action:@selector(inviteTo:) forControlEvents:UIControlEventTouchUpInside];        /*
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(inviteTo:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"Show View" forState:UIControlStateNormal];
        button.frame = CGRectMake(270.0, 10.0, 30.0, 30.0);//width and height should be same value
        button.clipsToBounds = YES;
        
        button.layer.cornerRadius = 20;//half of the width
        button.layer.borderColor=[UIColor redColor].CGColor;
        button.layer.borderWidth=2.0f;
        
        [cell.contentView addSubview:button];*/
    }
    else{
        NSLog(@"SI APP");
        cell.follow.titleLabel.text = @"SEGUI";
        [cell.follow addTarget:self action:@selector(seguiTo:) forControlEvents:UIControlEventTouchUpInside];
        /*
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addTo:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:indexPath.row];
        [button setTitle:@"Show View" forState:UIControlStateNormal];
        button.frame = CGRectMake(270.0, 10.0, 30.0, 30.0);//width and height should be same value
        button.clipsToBounds = YES;
        
        button.layer.cornerRadius = 20;//half of the width
        button.layer.borderColor=[UIColor greenColor].CGColor;
        button.layer.borderWidth=2.0f;
        
        [cell.contentView addSubview:button];*/
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) inviteTo:(id) sender{
    NSLog(@"%d",[sender tag]);
    [self share];
    
    //[sender tag];
    
}
- (void) seguiTo:(id) sender{
    NSLog(@"%d",[sender tag]);
    //[sender tag];
    
}

- (void)publishStory
{
    
    NSMutableDictionary *postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.eliteadvice.tk", @"link",
     @"asd", @"picture",
     @"asd", @"name",
     @"Il social Network che ti fa risparmiare.", @"caption",
     @"Scopri Elite Advice e risparmia su ogni acquisto.", @"description",
     nil];
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
             /*alertText = [NSString stringWithFormat:
              @"Posted action, id: %@",
              [result objectForKey:@"id"]];*/
             alertText = @"Hai consigliato correttamente \n il tuo prodotto";
         }
         // Show the result in an alert
         [[[TTAlertView alloc] initWithTitle:@"Ben Fatto!"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"Continua!"
                           otherButtonTitles:nil]
          show];

     }];
}
- (void)sendRequest {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:@{
                            @"social_karma": @"5",
                            @"badge_of_awesomeness": @"1"}
                            options:0
                            error:&error];
        if (!jsonData) {
            NSLog(@"JSON error: %@", error);
            return;
        }
        NSString *giftStr = [[NSString alloc]
                             initWithData:jsonData
                             encoding:NSUTF8StringEncoding];
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       giftStr, @"data",
                                       nil];
        
        // Display the requests dialog
        [FBWebDialogs
         presentRequestsDialogModallyWithSession:nil
         message:@"Learn how to make your iOS apps social."
         title:nil
         parameters:params
         handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
             if (error) {
                 // Error launching the dialog or sending the request.
                 NSLog(@"Error sending request.");
             } else {
                 if (result == FBWebDialogResultDialogNotCompleted) {
                     // User clicked the "x" icon
                     NSLog(@"User canceled request.");
                 } else {
                     // Handle the send request callback
                     NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                     if (![urlParams valueForKey:@"request"]) {
                         // User clicked the Cancel button
                         NSLog(@"User canceled request.");
                     } else {
                         // User clicked the Send button
                         NSString *requestID = [urlParams valueForKey:@"request"];
                         NSLog(@"Request ID: %@", requestID);
                     }
                 }
             }
         }];
    }

- (void) share{
    
    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
    [action setObject:@"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html"forKey:@"book"];
    
    FBOpenGraphActionShareDialogParams* params = [[FBOpenGraphActionShareDialogParams alloc]init];
    params.actionType = @"books.reads";
    params.action = action;
    params.previewPropertyName = @"book";
    
    // Show the Share dialog if available
    if([FBDialogs canPresentShareDialogWithOpenGraphActionParams:params]) {
        
        [FBDialogs presentShareDialogWithOpenGraphAction:[params action]
                                              actionType:[params actionType]
                                     previewPropertyName:[params previewPropertyName]
                                                 handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                     // handle response or error
                                                 }];
        
    }
    // If the Facebook app isn't available, show the Feed dialog as a fallback
    else {
        NSDictionary* params = @{@"name": @"Snow Crash",
                                 @"caption": @"Classic cyberpunk",
                                 @"description": @"In reality, Hiro Protagonist delivers pizza for Uncle Enzo's CosoNostra Pizza Inc., but in the Metaverse he's a warrior prince. ",
                                 @"link": @"https://apps.notrepro.net/fbsdktoolkit/objects/book/Snow-Crash.html",
                                 @"image": @"http://upload.wikimedia.org/wikipedia/en/d/d5/Snowcrash.jpg"};
        
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      // handle response or error
                                                  }];
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

@end
