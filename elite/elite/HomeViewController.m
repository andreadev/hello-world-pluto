//
//  HomeViewController.m
//  elite
//
//  Created by Andrea Barbieri on 22/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "HomeViewController.h"
#import "ProdottoViewController.h"
#import "Prodotto.h"
#import "AsyncImageView.h"
#import "RemoteImageView.h"

@interface HomeViewController (){
    NSMutableArray *ProdottiArray;
    NSMutableArray *TmpTitle;
    int scopeButtonPressedIndexNumber;
    NSString *url;
    int iol;
    
}

@end

@implementation HomeViewController
@synthesize prodotti,itemCell,filteredListContent;

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
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *menuButtonImage = [UIImage imageNamed:@"06-magnify"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    iol=0;
    
    self.title = @"Home";
    
    self.navigationItem.rightBarButtonItem = menuBarButton;
    ProdottiArray = [[NSMutableArray alloc] init];
    [self populateUserDetails];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://eliteitalia.altervista.org/webservice/Prodotti/get_all_products.php"]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    self.prodotti = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadProdotti];
    [self.tableView reloadData];
    
    
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
    return [filteredListContent count];
}


- (void) loadProdotti{
    
    for (int i = 0; i<[prodotti count]; i++) {
        Prodotto *prod = [[Prodotto alloc] init];
        prod.name = [[prodotti objectAtIndex:i] objectForKey:@"Name"];
        prod.prezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
        prod.oldprezzo = [[prodotti objectAtIndex:i] objectForKey:@"Price"];
        prod.where = [[prodotti objectAtIndex:i] objectForKey:@"Store_ID"];
        prod.url = [[prodotti objectAtIndex:i] objectForKey:@"ImageUrl"];
        [ProdottiArray  addObject:prod];
    }
    // crea la lista filtrata, inizializzandola con il numero di elementi dell'array "lista"
	filteredListContent = [[NSMutableArray alloc] initWithCapacity: [ProdottiArray count]];
	//inserisce in questa  nuova lista gli elementi della lista originale
	[filteredListContent addObjectsFromArray:ProdottiArray];
    

    
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
        /*
        //add AsyncImageView to cell
		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 70.0f, 70.0f)];
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		imageView.clipsToBounds = YES;
		imageView.tag = IMAGE_VIEW_TAG;
		[itemCell addSubview:imageView];
		//[imageView release];
		
		//common settings
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.indentationWidth = 84.0f;
		cell.indentationLevel = 1;*/
        cell = itemCell;
        
    }
    NSLog(@"entro");
    //NSLog(@"%@",[filteredListContent objectAtIndex:indexPath.row]);
    //NSString *url = [[NSString alloc] initWithFormat:@"http://%@",[[filteredListContent objectAtIndex:indexPath.row] objectForKey:@"ImageUrl"]] ;
    
    //NSURL *imageURL = [[NSURL alloc] initWithString:url];
    //NSURL *imageURL = [[NSURL alloc] initWithString:@"http://eliteitalia.altervista.org/webservice/product_images/mela.jpg"];
   
    
    //cell.prodImage.image = [UIImage imageNamed:@"53-house"];
    /*dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.prodImage.image = image;
        });
    });
    */
    
    Prodotto *pro = [filteredListContent objectAtIndex:indexPath.row];
    
        
    cell.nameProd.text = pro.name;
    cell.Price.text = pro.prezzo;
    cell.oldPrice.text =  pro.oldprezzo;
    cell.whereProd.text = pro.where;
    
    //get image view
	//AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:IMAGE_VIEW_TAG];
	
    
    
    //cancel loading previous image for cell
    //[[AsyncImageLoader sharedLoader] cancelLoadingURL:imageView.imageURL];
    
    //NSLog(@"%@",pro.url);
    /*
    if ([pro.url rangeOfString:@"http"].location == NSNotFound) {
        
        url = [[NSString alloc] initWithFormat:@"http://wwww.%@",pro.url ];
    } else {
        NSLog(@"string contains bla!");
        url = [[NSString alloc] initWithString:pro.url];
    }
    */
    NSLog(@"%@",url);
    //UIImageView *im;
    //[im setImageFromUrl:[[NSURL alloc] initWithString:pro.url] defaultImage:[UIImage imageNamed:@"53-house"]];
    //cell.imageView.image = im.image;
    
    [cell.imageView setImageFromUrl:[[NSURL alloc] initWithString:pro.url] defaultImage:[UIImage imageNamed:@"53-house"]];
    //[cell.imageView setImageFromUrl:[[NSURL alloc] initWithString:pro.url] defaultImage:@"53-house"];
    //load the image
    //imageView.imageURL = [[NSURL alloc] initWithString:url];
    
    return cell;
}

- (void) viewWillAppear:(BOOL)animated{
    self.tableView.contentOffset = CGPointMake(0.0, 90.0);
}

-(void)pressedLeftButton
{
    
    if ( iol == 0 ){
        NSLog(@"schiacciato");
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        iol=1;
    }
    else{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 0, 0) animated:YES];
        self.tableView.contentOffset = CGPointMake(0.0, 90.0);
        iol=0;
    }
    //self.tableView.contentOffset = CGPointMake(0.0, 0.0);
        
    
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
        [filteredListContent removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 //self.title = user.name;
                 //NSLog(@"%@", user.name);
                 //NSLog(@"%@", user.id);
             }
         }];
    }
}


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
     ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.prod = [filteredListContent objectAtIndex:indexPath.row];
    
     [self.navigationController pushViewController:detailViewController animated:YES];
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSLog(@"primo");
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)saearchBar {
    [self.filteredListContent removeAllObjects];
    [self.filteredListContent addObjectsFromArray: ProdottiArray];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    scopeButtonPressedIndexNumber = [NSNumber numberWithInt:selectedScope];
    NSLog(@"scope %d",scopeButtonPressedIndexNumber);
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope{
    
	/*
	 Update the filtered array based on the search text and scope.
	 */
	[self.filteredListContent removeAllObjects]; // First clear the filtered array.
    NSLog(@"qui");

	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
    
    for (int i = 0; i<[ProdottiArray count]; i++) {
        Prodotto *prof = [ProdottiArray objectAtIndex:i];
        NSComparisonResult result = [prof.name compare:searchText options:NSCaseInsensitiveSearch range:NSMakeRange(0, [searchText length])];
		if (result == NSOrderedSame){
			[filteredListContent addObject:prof];
		}
    }
    
}
@end
