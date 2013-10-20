//
//  ProductsView.m
//  elite
//
//  Created by Andrea Barbieri on 30/08/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProductsView.h"
#import "GAI.h"


@interface ProductsView (){
    NSMutableArray *expandedPaths;
    NSString *numberString;
    UITextView *descrizioneT;
    CXPhotoBrowser *photobrowser;
    NSMutableArray *photoDataSource;
    CXBrowserNavBarView *navBarView;
    CXBrowserToolBarView *toolBarView;
    CXPhoto *image;
}

#define BROWSER_TITLE_LBL_TAG 12731
#define BROWSER_DESCRIP_LBL_TAG 178273
#define BROWSER_LIKE_BTN_TAG 12821

@end

@implementation ProductsView

@synthesize imageProd,codice,prezzo,prod,name,where,oldprezzo,from,descrizione,isWishlist,isProfilo;

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
    expandedPaths = [[NSMutableArray alloc] init];
    self.tableView.scrollEnabled = NO;
    //footerView = [[UIView alloc] initWithFrame:CGRectMake(320, 40, 200, 52)];
    photobrowser = [[CXPhotoBrowser alloc] initWithDataSource:self delegate:self];
    if(![isWishlist isEqualToString:@"yes"]){
        UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"+ WishList" style:UIBarButtonItemStylePlain target:self action:@selector(pressedRightButton)];
        self.navigationItem.rightBarButtonItem = anotherButton;
    }
    //[headerView addSubview:titolo];
    
    //[self.tableView setTableHeaderView:headerView];
    //[self.tableView setTableFooterView:footerView];
    
}

- (void) viewWillAppear:(BOOL)animated{
    
    
    
    //self.where.text = prod.where;
    /*float a = [prod.oldprezzo floatValue];
    float sconto = [prod.privateCodeValue floatValue];
    //NSLog(@"%f",a);
    a = a-(a*sconto);
    //NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    self.prezzo.text = numberString;*/
    self.oldprezzo.text = prod.oldprezzo;
    self.from.text = prod.consigliato;
    //self.title = prod.name;
    self.imageProd.layer.cornerRadius = 9.0 ;
    self.imageProd.layer.masksToBounds = YES ;
    self.imageProd.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.imageProd.layer.borderWidth = 3.0 ;
    //imageProd.image = image;
    
}

- (void) viewDidAppear:(BOOL)animated{
    NSArray * array = [prod.urlfoto componentsSeparatedByString:@"/"];
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@", WEBSERVICEURL, [array objectAtIndex:[array count]-1] ];
    
    [imageProd setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:prod.idprodotto];
        // defaultTracker originally declared in AppDelegate.m
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        
        // manual screen tracking
        [tracker sendView:@"Products"];
    
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 35.;
    }
    else if (indexPath.row == 1){
        return 105.;
    }
    else if (indexPath.row == 2){
        return 70.;
    }
    if ([expandedPaths containsObject:indexPath]) {
        //NSLog(@"ricarico cella");
        return 60.;
    }
    else {
        return 44.;
    }
    return 44.;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Where we configure the cell in each row
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0) {
        UILabel *prices = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 30)];
        prices.font = [UIFont fontWithName:@"Helvetica" size:15];
        prices.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        prices.backgroundColor = [UIColor clearColor];
        prices.text = @"Prezzo:";
        prices.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:prices];
        
        float a = [prod.prezzo floatValue];
        float sconto = [prod.privateCodeValue floatValue];
        
        
        //NSLog(@"%f",a);
        a = a-(a*sconto);

        //NSLog(@"Prezzo scontato %f",a);
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSString *numbers = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
        if ([numbers characterAtIndex:0] == ',' ) {
            numbers = [@"0" stringByAppendingString:numbers];
        }
        
        
        
        UILabel *newpricesVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 2, 70, 30)];
        newpricesVal.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        newpricesVal.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        newpricesVal.backgroundColor = [UIColor clearColor];
        newpricesVal.text = [prod.prezzo stringByAppendingString:@"  €"];
        newpricesVal.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:newpricesVal];
        
        
        UILabel *pricesVal = [[UILabel alloc]initWithFrame:CGRectMake(200, 2, 70, 30)];
        pricesVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        pricesVal.textColor = [UIColor blackColor];
        pricesVal.backgroundColor = [UIColor clearColor];
        pricesVal.text = [numbers stringByAppendingString:@"  €"];
        pricesVal.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:pricesVal];
        
        if ([isProfilo isEqualToString:@"YES"]){
            pricesVal.text = prod.oldprezzo;
            //NSLog(@"CASAAAAAAAA");
        }
        
        
        UIImageView *sbarra = [[UIImageView alloc] initWithFrame:CGRectMake(125, 13, 51, 15)];
        sbarra.image = [UIImage imageNamed:@"linea"];
        [cell.contentView addSubview:sbarra];
        
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1){
        UILabel *wheres = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 30)];
        wheres.font = [UIFont fontWithName:@"Helvetica" size:15];
        wheres.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        wheres.backgroundColor = [UIColor clearColor];
        wheres.text = @"Dove:";
        wheres.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:wheres];
        
        UILabel *wheresVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 2, 200, 30)];
        wheresVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        wheresVal.textColor = [UIColor blackColor];
        wheresVal.backgroundColor = [UIColor clearColor];
        wheresVal.text = prod.where;
        [cell.contentView addSubview:wheresVal];
        //NSLog(@"%@",prod.address);
        
        UILabel *wheresVall = [[UILabel alloc]initWithFrame:CGRectMake(120, 22, 200, 60)];
        wheresVall.font = [UIFont fontWithName:@"Helvetica" size:15];
        wheresVall.textColor = [UIColor blackColor];
        wheresVall.backgroundColor = [UIColor clearColor];
        wheresVall.text = prod.address;
        wheresVall.lineBreakMode = NSLineBreakByTruncatingTail;
        wheresVall.numberOfLines = 0;
        [cell.contentView addSubview:wheresVall];
        //NSLog(@"%@",prod.address);
        
        UILabel *dist = [[UILabel alloc]initWithFrame:CGRectMake(10, 72, 200, 30)];
        dist.font = [UIFont fontWithName:@"Helvetica" size:15];
        dist.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        dist.backgroundColor = [UIColor clearColor];
        dist.text = @"Sei distante:";
        dist.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:dist];
        
        UILabel *distanceVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 72, 200, 30)];
        distanceVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        distanceVal.textColor = [UIColor blackColor];
        distanceVal.backgroundColor = [UIColor clearColor];
        float a = [prod.distance floatValue];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setMaximumFractionDigits:1];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        NSString *number= [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
        if ([number characterAtIndex:0] == ',' ) {
            number = [@"0" stringByAppendingString:number];
        }
        number = [number stringByAppendingString:@" KM"];
        distanceVal.text = number;
        [cell.contentView addSubview:distanceVal];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 2){
        
        UILabel *consigliatos = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        consigliatos.font = [UIFont fontWithName:@"Helvetica" size:15];
        consigliatos.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        consigliatos.backgroundColor = [UIColor clearColor];
        consigliatos.text = @"Consigliato da:";
        consigliatos.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:consigliatos];
        
        UILabel *consigliatosVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 200, 30)];
        consigliatosVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        consigliatosVal.textColor = [UIColor blackColor];
        consigliatosVal.backgroundColor = [UIColor clearColor];
        consigliatosVal.text = prod.consigliato;
        [cell.contentView addSubview:consigliatosVal];
        
        UILabel *codicesconto = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 200, 30)];
        codicesconto.font = [UIFont fontWithName:@"Helvetica" size:15];
        codicesconto.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        codicesconto.backgroundColor = [UIColor clearColor];
        codicesconto.text = @"Codice Sconto:";
        codicesconto.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:codicesconto];
        
        UILabel *codicescontoVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 35, 200, 30)];
        codicescontoVal.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        codicescontoVal.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        codicescontoVal.backgroundColor = [UIColor clearColor];
        codicescontoVal.text = prod.codice;
        [cell.contentView addSubview:codicescontoVal];
        
    }
    else if (indexPath.row == 3){
        cell.textLabel.text = @"Descrizione";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        cell.textLabel.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        /*
        if ([expandedPaths containsObject:indexPath]) {
            descrizioneT = [[UITextView alloc]initWithFrame:CGRectMake(120, 5, 200, 50)];
            descrizioneT.font = [UIFont fontWithName:@"Helvetica" size:15];
            descrizioneT.textColor = [UIColor blackColor];
            descrizioneT.backgroundColor = [UIColor clearColor];
            descrizioneT.text = prod.desc;
            descrizioneT.editable = NO;
            [cell.contentView addSubview:descrizioneT];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }*/
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 125)];
    //headerView.backgroundColor = [UIColor ]; //mainLightColor is a blue color
    
    //UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, 200, 20)];
    //label.backgroundColor = [UIColor clearColor];
    //label.textColor = [UIColor blueColor];
    //label.text = @"Past Activities";
    //[headerView addSubview:label];*/
    
    imageProd = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 90, 90)];
    imageProd.layer.cornerRadius = 9.0 ;
    imageProd.layer.masksToBounds = YES ;
    imageProd.layer.borderColor = [UIColor whiteColor].CGColor ;
    imageProd.layer.borderWidth = 3.0 ;
    imageProd.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    [imageProd addGestureRecognizer:tap];
    
    [headerView addSubview:imageProd];
    
    
    UILabel *titolo = [[UILabel alloc]initWithFrame:CGRectMake(100, 20, 210, 40)];
    titolo.font = [UIFont fontWithName:@"Helvetica" size:18];
    titolo.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
    titolo.backgroundColor = [UIColor clearColor];
    titolo.text = prod.name;
    titolo.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:titolo];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 52)];
    UIButton *wishlist = [[UIButton alloc] initWithFrame:CGRectMake(60, 0, 200, 52)];
    [wishlist  addTarget:self action:@selector(pressedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [wishlist setBackgroundImage:[UIImage imageNamed:@"wishlist"] forState:UIControlStateNormal];
    //[footerView addSubview:wishlist];
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 35.0;
}

-(void) imageTapped{
    //NSLog(@"Tapped");
    NSArray * array = [prod.urlfoto componentsSeparatedByString:@"/"];
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@", WEBSERVICEURL, [array objectAtIndex:[array count]-1] ];
    
    image = [[CXPhoto alloc] initWithURL:[NSURL URLWithString:image_url]];
    //[photoDataSource addObject:photo];
    //image = [[CXPhoto alloc] initWithImage:[UIImage imageNamed:@"camerabianca.png"]];
    [photoDataSource addObject:image];
    //[self.navigationController pushViewController:photobrowser animated:YES];
    [self presentViewController:photobrowser animated:YES completion:nil];
}

# pragma photoBrowser

- (NSUInteger)numberOfPhotosInPhotoBrowser:(CXPhotoBrowser *)photoBrowser
{
    return 1;
}

- (id <CXPhotoProtocol>)photoBrowser:(CXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    
    return image;
    
}
- (CXBrowserNavBarView *)browserNavigationBarViewOfOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    if (!navBarView)
    {
        navBarView = [[CXBrowserNavBarView alloc] initWithFrame:frame];
        
        [navBarView setBackgroundColor:[UIColor clearColor]];
        
        UIView *bkgView = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgView setBackgroundColor:[UIColor blackColor]];
        bkgView.alpha = 0.2;
        bkgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [navBarView addSubview:bkgView];
        
        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [doneButton setTitle:NSLocalizedString(@"Fatto",@"Dismiss button title") forState:UIControlStateNormal];
        [doneButton setFrame:CGRectMake(size.width - 60, 20, 50, 30)];
        [doneButton addTarget:self action:@selector(photoBrowserDidTapDoneButton:) forControlEvents:UIControlEventTouchUpInside];
        [doneButton.layer setMasksToBounds:YES];
        [doneButton.layer setCornerRadius:4.0];
        [doneButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [doneButton.layer setBorderColor:colorref];
        doneButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
        [navBarView addSubview:doneButton];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [titleLabel setFrame:CGRectMake((size.width - 60)/2, 10, 60, 40)];
        [titleLabel setCenter:navBarView.center];
        [titleLabel setTextAlignment:NSTextAlignmentCenter];
        [titleLabel setFont:[UIFont boldSystemFontOfSize:20.]];
        [titleLabel setTextColor:[UIColor whiteColor]];
        [titleLabel setBackgroundColor:[UIColor clearColor]];
        titleLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [titleLabel setTag:BROWSER_TITLE_LBL_TAG];
        [navBarView addSubview:titleLabel];
    }
    
    return navBarView;
}

- (CXBrowserToolBarView *)browserToolBarViewOfPhotoBrowser:(CXPhotoBrowser *)photoBrowser withSize:(CGSize)size
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = size;
    
    if (!toolBarView)
    {
        toolBarView = [[CXBrowserToolBarView alloc] initWithFrame:frame];
        [toolBarView setBackgroundColor:[UIColor clearColor]];
        
        UIImageView *bkgImageView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, 0, size.width, size.height)];
        [bkgImageView setImage:[UIImage imageNamed:@"toolbarBKG.png"]];
        bkgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [toolBarView addSubview:bkgImageView];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [likeButton setTitle:NSLocalizedString(@"+ Wishlist",@"") forState:UIControlStateNormal];
        [likeButton setFrame:CGRectMake(20, 10, 70, 30)];
        [likeButton addTarget:self action:@selector(pressedRightButton) forControlEvents:UIControlEventTouchUpInside];
        [likeButton.layer setMasksToBounds:YES];
        [likeButton.layer setCornerRadius:4.0];
        [likeButton.layer setBorderWidth:1.0];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1, 1, 1, 1 });
        [likeButton.layer setBorderColor:colorref];
        likeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [likeButton setTag:BROWSER_LIKE_BTN_TAG];
        [toolBarView addSubview:likeButton];
        /*
        UILabel *descripLabel = [[UILabel alloc] init];
        [descripLabel setFrame:CGRectMake( 10, 50, size.width - 20, size.height - 50)];
        [descripLabel setTextAlignment:NSTextAlignmentLeft];
        [descripLabel setFont:[UIFont boldSystemFontOfSize:12.]];
        [descripLabel setTextColor:[UIColor whiteColor]];
        [descripLabel setBackgroundColor:[UIColor clearColor]];
        [descripLabel setNumberOfLines:0];
        descripLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [descripLabel setTag:BROWSER_DESCRIP_LBL_TAG];
        [toolBarView addSubview:descripLabel];*/
    }
    
    return toolBarView;
}
#pragma mark - CXPhotoBrowserDelegate

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    UILabel *titleLabel = (UILabel *)[navBarView viewWithTag:BROWSER_TITLE_LBL_TAG];
    if (titleLabel)
    {
        titleLabel.text = [NSString stringWithFormat:@"%i di %i", index+1, photoBrowser.photoCount];
    }
    
    UIButton *likeButton = (UIButton *)[toolBarView viewWithTag:BROWSER_LIKE_BTN_TAG];
    if (likeButton)
    {
        
        [likeButton setTitle:NSLocalizedString(@"+ Whislist",@"") forState:UIControlStateNormal];
    }
    /*
    UILabel *descripLabel = (UILabel *)[toolBarView viewWithTag:BROWSER_DESCRIP_LBL_TAG];
    if (descripLabel)
    {
        descripLabel.text = prod.desc;
    }*/
}

- (void)photoBrowser:(CXPhotoBrowser *)photoBrowser didFinishLoadingWithCurrentImage:(UIImage *)currentImage
{
    if (currentImage) {
        //loading success
    }
    else {
        //loading failure
    }
}

- (BOOL)supportReload
{
    return YES;
}
#pragma mark - PhotBrower Actions
- (void)photoBrowserDidTapDoneButton:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoBrowserDidTapLIKEButton:(UIButton *)sender
{
    
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
- (void) pressedRightButton{
    //aggiungi a whish list!
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    ////NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              valUser, @"id_p",
                              prod.idprodotto, @"id_prod",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *urlwish = [[NSString alloc] initWithFormat:@"%@Wishlist/add_prod.php", WEBSERVICEURL ];
    [request setURL:[NSURL URLWithString:urlwish]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    //NSLog(@"Reply: %@", theReply);
    ////NSLog(@"%@",theReply);
    
    if ([theReply rangeOfString:@"Array1"].location == NSNotFound) {
        //NSLog(@"ADD NON RIUSCITO");
        TTAlertView *okAlert = [[TTAlertView alloc] initWithTitle:@"Prodotto non Aggiunto!" message:@"Il Prodotto è già nella whishlist!" delegate:nil cancelButtonTitle:@"Continua" otherButtonTitles:nil];
        [okAlert show];
    } else {
        //NSLog(@"ADD LOGIN RIUSCITO");
        
        TTAlertView *okAlert = [[TTAlertView alloc] initWithTitle:@"Successo!" message:@"Prodotto aggiunto correttamente alla tua wishlist" delegate:nil cancelButtonTitle:@"Continua" otherButtonTitles:nil];
        [okAlert show];
        
    }
    
    
}

#pragma mark - Table view delegate

 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 [tableView deselectRowAtIndexPath:indexPath animated:YES];
 if (indexPath.row == 3){
     /*if ([expandedPaths containsObject:indexPath]){
         [expandedPaths removeObject:indexPath];
         descrizioneT.text = Nil;
     }
     else{
         [expandedPaths addObject:indexPath];
         //NSLog(@"ciao");
     }
      [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     //NSLog(@"%@",indexPath);
     */
     DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
     UINavigationController *navDet = [[UINavigationController alloc] initWithRootViewController:detail];
     detail.detail = prod.desc;
     [self presentViewController:navDet animated:YES completion:nil];
 }
 }



@end
