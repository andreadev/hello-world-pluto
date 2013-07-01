//
//  ResultViewController.m
//  elite
//
//  Created by Andrea Barbieri on 07/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ResultViewController.h"
#import "HomeViewController.h"
#import "AppDelegate.h"

@interface ResultViewController (){
    ODRefreshControl *refreshControl;
    int iol;
    NSMutableArray *ProdottiArray;
}

@end

@implementation ResultViewController
@synthesize urlProdotti,prodotti,itemCell,redLine;

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
    
    refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
    UIImage *menuButtonImage = [UIImage imageNamed:@"06-magnify"];
    UIButton *btnToggle = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btnToggle setImage:menuButtonImage forState:UIControlStateNormal];
    btnToggle.frame = CGRectMake(0, 0, menuButtonImage.size.width, menuButtonImage.size.height);
    UIBarButtonItem *menuBarButton = [[UIBarButtonItem alloc] initWithCustomView:btnToggle];
    [btnToggle addTarget:self action:@selector(pressedLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [btnToggle showsTouchWhenHighlighted];
    iol=0;
    //self.title = @"Home";
    
    self.navigationItem.rightBarButtonItem = menuBarButton;
    ProdottiArray = [[NSMutableArray alloc] init];
    //[self populateUserDetails];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) loadProducts{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlProdotti]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl{
    NSLog(@"pull");
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
    [refreshControl endRefreshing];
    
    
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
        prod.urlfoto = [[prodotti objectAtIndex:i] objectForKey:@"ImageUrl"];
        prod.categoria = [[prodotti objectAtIndex:i] objectForKey:@"Category"];
        prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
        prod.consigliato = [[prodotti objectAtIndex:i] objectForKey:@"Consigliato"];
        //prod.desc = [[prodotti objectAtIndex:i] objectForKey:@"Desc"];
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
    Prodotto *pro = [filteredListContent objectAtIndex:indexPath.row];
    
    
    cell.nameProd.text = pro.name;
    float a = [pro.oldprezzo floatValue];
    NSLog(@"%f",a);
    a = a-(a*0.1);
    NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    
    cell.Price.text = [numberString stringByAppendingString:@"  €"];
    cell.oldPrice.text =  [pro.oldprezzo stringByAppendingString:@"  €"];;
    cell.whereProd.text = pro.where;
    cell.prodImage.layer.cornerRadius = 9.0 ;
    cell.prodImage.layer.masksToBounds = YES ;
    cell.prodImage.layer.borderColor = [UIColor whiteColor].CGColor ;
    cell.prodImage.layer.borderWidth = 3.0 ;
    
    NSArray * array = [pro.urlfoto componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@",WEBSERVICEURL ,[array objectAtIndex:[array count]-1] ];
    
    //NSLog(@"%@",[array objectAtIndex:i]);
    NSLog(@"%@",pro.urlfoto);
    
    [cell.prodImage setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"53-house"]];
    //[cell.imageView setImageFromUrl:[[NSURL alloc] initWithString:pro.url] defaultImage:@"53-house"];
    //load the image
    //imageView.imageURL = [[NSURL alloc] initWithString:url];
    
    return cell;
}

- (void) viewWillAppear:(BOOL)animated{
    //self.tableView.contentOffset = CGPointMake(0.0, 90.0);
    NSLog(@"%@", urlProdotti);
    prodotti = nil;
    [ProdottiArray removeAllObjects];
    [self loadProducts];
    
    [self.tableView reloadData];
    
}

-(void)pressedLeftButton
{
    
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ProdottoViewController *detailViewController = [[ProdottoViewController alloc] initWithNibName:@"ProdottoViewController" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    detailViewController.prod = [filteredListContent objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)viewDidUnload {
    [self setRedLine:nil];
    [super viewDidUnload];
}


@end
