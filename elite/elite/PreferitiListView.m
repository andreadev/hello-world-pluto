//
//  PreferitiListView.m
//  elite
//
//  Created by Andrea Barbieri on 18/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "PreferitiListView.h"
#import "User.h"
#import "PreferitiView.h"
#import "AppDelegate.h"
#import "SelectViewController.h"
#import "FBFriend.h"
#import "GAI.h"

@interface PreferitiListView (){
    NSMutableArray *AmiciArray;
    PreferitiView *pref;
    SelectViewController *seleziona;
    int x;
}

@end

@implementation PreferitiListView
@synthesize preferiti,itemCell;
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
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    //pref = [[PreferitiView alloc] initWithNibName:@"PreferitiView" bundle:nil];
    seleziona = [[SelectViewController alloc] initWithNibName:@"SelectViewController" bundle:nil];
    x=0;
    UIImage *menuButtonImage = [UIImage imageNamed:@"cerca"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = menuBarButton;
    AmiciArray = [[NSMutableArray alloc] init];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor lightGrayColor];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    //[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.refreshControl beginRefreshing];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //[self pressedLeftButton];
    //[self loadPreferiti];
}

- (void) viewWillAppear:(BOOL)animated{
    [AmiciArray removeAllObjects];
    
    [self loadPreferiti];
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    //NSLog(@"pull");
    preferiti = nil;
    [AmiciArray removeAllObjects];
    [self loadPreferiti];
}

- (void) loadPreferiti{
   
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    
    
    
    NSString *urlPref = [[NSString alloc] initWithFormat:@"%@Preferiti/get_preferiti.php?user=%@",WEBSERVICEURL,valUser];
    //NSLog(@"%@",urlPref);
    
    
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
    [self loadPrefer];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
    
}

- (void) loadPrefer{
    
    for (int i = 0; i<[preferiti count]; i++) {
        @try {
            // do something that might throw an exception
            User *amico = [[User alloc] init];
            amico.name = [[preferiti objectAtIndex:i] objectForKey:@"name_f"];
            amico.idfacebook = [[preferiti objectAtIndex:i] objectForKey:@"id_facebook"];
            amico.idelite = [[preferiti objectAtIndex:i] objectForKey:@"id_f"];
            [AmiciArray  addObject:amico];
        }
        @catch (NSException *exception) {
            // deal with the exception
            ////NSLog(@"eccezione");
            if (x==0){
                
                [self.navigationController pushViewController:seleziona animated:YES];
                x=1;
            }
        }
        
        //prod.consigliato = [[prodotti objectAtIndex:i] objectForKey:@"Consigliato"];
        //prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
            
    }
    //[MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
}

- (void) pressedLeftButton{
    [self.navigationController pushViewController:seleziona animated:YES];
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
    return [AmiciArray count];
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
    User *amico = [AmiciArray objectAtIndex:indexPath.row];
    cell.labelNome.text = amico.name;
    [cell.follow setTitle:@"" forState:UIControlStateNormal];
    [cell.follow setTag:amico.idfacebook];
    [cell.follow setBackgroundImage:[UIImage imageNamed:@"seguogianew"] forState:UIControlStateNormal];
    cell.follow.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell.follow addTarget:self action:@selector(nonseguiTo:) forControlEvents:UIControlEventTouchUpInside];
    ////NSLog(@"ID FB ____> %@", amico.idfacebook);
    if(![amico.idfacebook isEqualToString:@""]){
        NSString *image_url= [[NSString alloc] initWithFormat:@"http://graph.facebook.com/%@/picture", amico.idfacebook];
        //NSLog(@"%@", image_url);
        [cell.imageName setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:amico.idelite];
    }
    else{
        cell.imageName.image = [UIImage imageNamed:@"111-user"];
        cell.imageName.opaque = YES;
        cell.imageName.alpha = 0.4;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}


- (void) nonseguiTo:(id) sender{
    [sender setBackgroundImage:[UIImage imageNamed:@"seguinew"] forState:UIControlStateNormal];
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    //NSLog(@"%d",indexPath.row);
    
    User *amicofb = [AmiciArray objectAtIndex:indexPath.row];
    [AmiciArray removeObjectAtIndex:indexPath.row];
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    ////NSLog(@"PRESSED: %@ -- %@",amicofb.,pass.text );
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              valUser, @"id_p",
                              amicofb.idelite, @"id_f",
                              nil];
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlnick = [[NSString alloc] initWithFormat:@"%@Preferiti/remove_pref.php", WEBSERVICEURL ];
    
    [request setURL:[NSURL URLWithString:urlnick]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    [self.tableView reloadData];
    ////NSLog(@"%@",theReply);
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Favorites Facebook"];
}

@end
