//
//  FindUserView.m
//  elite
//
//  Created by Andrea Barbieri on 28/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "FindUserView.h"
#import "FBFriend.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface FindUserView (){
    NSArray *friends;
    NSMutableArray *amici;
    NSMutableDictionary *postPara;
    NSString *idialog;
    NSString *usersearch;
}

@end

@implementation FindUserView
@synthesize itemCell,searchBar;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
    self.navigationItem.titleView = navImage;
    
    searchBar.delegate = self;
    //[self getFriends];
    
    /*UIImage *menuButtonImage = [UIImage imageNamed:@"06-magnify"];
     UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
     [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
     btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
     UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
     [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
     self.navigationItem.rightBarButtonItem = menuBarButton;*/
    
    amici = [[NSMutableArray alloc] init];
    
    //self.title = @"Preferiti";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)getFriends{
    
    NSString *url = [[NSString alloc] initWithFormat:@"%@Utenti/find_user.php?user=%@", WEBSERVICEURL,usersearch ];
    NSLog(@"%@",url);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
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
    if ([friends count] == 0){
        FBFriend *fb = [[FBFriend alloc] init];
    //fb.hasapp = [[friends objectAtIndex:i] objectForKey:@"hasapp"];
        fb.name = @"Nessun utente trovato";
        fb.idfb= nil;
    }
    else{
        for (int i = 0; i<[friends count]; i++) {
            NSLog(@"trovato");
            FBFriend *fb = [[FBFriend alloc] init];
            fb.hasapp = @"1";
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
        [self.tableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	//il numero di righe deve corrispondere al numero di elementi della lista
	return [friends count];
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
    NSLog(@"%@",amicofb.hasapp);
    //int hasapp = amicofb.hasapp;
    NSString *hasApp = [[NSString alloc] initWithFormat:@"%@",amicofb.hasapp ];
    //NSLog(hasapp ? @"Yes" : @"No");
    NSLog(@"%@",hasApp);
    
    if ([hasApp isEqualToString:@"0"]) {
        //INVITA
        NSLog(@"NO APP");
        [cell.follow setTitle:@"" forState:UIControlStateNormal];
        [cell.follow setBackgroundImage:[UIImage imageNamed:@"invita"] forState:UIControlStateNormal];
        [cell.follow setTag:amicofb.idfb];
        [cell.follow addTarget:self action:@selector(inviteTo:) forControlEvents:UIControlEventTouchUpInside];
        /*
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
    else if ([hasApp isEqualToString:@"1"]){
        //SEGUI
        NSLog(@"SI APP");
        [cell.follow setTitle:@"" forState:UIControlStateNormal];
        [cell.follow setTag:amicofb.idfb];
        [cell.follow setBackgroundImage:[UIImage imageNamed:@"segui"] forState:UIControlStateNormal];
        //[consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
        NSLog(@"%@",amicofb.idfb);
        NSLog(@"%@",amicofb.name);
        
        cell.follow.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    else if ([hasApp isEqualToString:@"2"]){
        //SEGUI
        NSLog(@"SI APP");
        [cell.follow setTitle:@"" forState:UIControlStateNormal];
        [cell.follow setTag:amicofb.idfb];
        [cell.follow setBackgroundImage:[UIImage imageNamed:@"seguogia"] forState:UIControlStateNormal];
        //[consiglia setBackgroundImage:[UIImage imageNamed:@"consigliapapress"] forState:UIControlStateHighlighted];
        NSLog(@"%@",amicofb.idfb);
        
        cell.follow.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cell.follow addTarget:self action:@selector(nonseguiTo:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (void) nonseguiTo:(id) sender{
    [sender setBackgroundImage:[UIImage imageNamed:@"segui"] forState:UIControlStateNormal];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    FBFriend *amicofb = [amici objectAtIndex:indexPath.row];
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
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
    NSString *urlnick = [[NSString alloc] initWithFormat:@"%@Preferiti/removepreferiti.php", WEBSERVICEURL ];
    
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
- (void) seguiTo:(id) sender{
    //100002916262674
    NSLog(@"%d",[sender tag]);
    NSLog(@"Segui");
    [sender setBackgroundImage:[UIImage imageNamed:@"seguogia"] forState:UIControlStateNormal];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    NSLog(@"%d",indexPath.row);
    FBFriend *amicofb = [amici objectAtIndex:indexPath.row];
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
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
    NSString *urlnick = [[NSString alloc] initWithFormat:@"%@Preferiti/addpreferitielite.php", WEBSERVICEURL ];
    
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
#pragma mark - search
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    //[self filterContentForSearchText:searchString scope:
	 //[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    
    //[self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 //[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)saearchBar {
    [amici removeAllObjects];
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBarr{
    NSLog(@"bottone");
    NSLog(@"%@",searchBarr.text);
    usersearch = searchBarr.text;
    
    [self getFriends];

}



@end
