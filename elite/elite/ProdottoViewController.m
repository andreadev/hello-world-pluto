//
//  ProdottoViewController.m
//  elite
//
//  Created by Andrea Barbieri on 25/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdottoViewController.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface ProdottoViewController (){
    NSArray *lista;
    NSMutableArray *datiList;
    NSString *numberString;
    
}

@end

@implementation ProdottoViewController
@synthesize prod,name,where,prezzo,oldprezzo,from,descrizione,codice,imageProd,Scrollview,tabellaView;

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
    //lista = [[NSArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consiliato da:", @"Codice Sconto:",@"Descrizione" ,nil];
    datiList = [[NSMutableArray alloc] init];
    //lista = [[NSMutableArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consigliato da:",@"Codice Sconto:","Descrizione:", nil];
    //UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"WhishList" style:UIBarButtonItemStylePlain target:self action:@selector(pressedRightButton)];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    
    [Scrollview setScrollEnabled:YES];//Abilitiamo lo scroll
    
    [Scrollview setContentSize:(CGSizeMake(320,480))];
    
    CGRect tbFrame = [tabellaView frame];
    tbFrame.size.height = 500;
    [tabellaView setFrame:tbFrame];
    UIButton *wishlist = [[UIButton alloc] initWithFrame:CGRectMake(60, 400, 200, 52)];
    [wishlist  addTarget:self action:@selector(pressedRightButton) forControlEvents:UIControlEventTouchUpInside];
    [wishlist setBackgroundImage:[UIImage imageNamed:@"wishlist"] forState:UIControlStateNormal];
    [Scrollview addSubview:wishlist];
    
    /*queste sono<span id="more-1890"></span> le dimesione 320 larghezza e 900 la lunghezza*/
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    
    
    self.name.text = prod.name;
    //self.where.text = prod.where;
    float a = [prod.oldprezzo floatValue];
    NSLog(@"%f",a);
    a = a-(a*0.1);
    NSLog(@"%f",a);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:2];
    [formatter setRoundingMode: NSNumberFormatterRoundUp];
    numberString = [formatter stringFromNumber:[NSNumber numberWithFloat:a]];
    self.prezzo.text = numberString;
    self.oldprezzo.text = prod.oldprezzo;
    self.from.text = prod.consigliato;
    //self.title = prod.name;
    self.imageProd.layer.cornerRadius = 9.0 ;
    self.imageProd.layer.masksToBounds = YES ;
    self.imageProd.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.imageProd.layer.borderWidth = 3.0 ;
    //imageProd.image = image;
    NSArray * array = [prod.urlfoto componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"%@product_images/thumb/%@", WEBSERVICEURL, [array objectAtIndex:[array count]-1] ];
    
    [imageProd setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"girandola@2x.gif"] andId:prod.idprodotto];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pressedRightButton{
    //aggiungi a whish list!
    //CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    //NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"Username"];
    //NSLog(@"PRESSED: %@ -- %@",mail.text,pass.text );
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              valUser, @"id_p",
                              prod.idprodotto, @"id_prod",
                              nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
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
    NSLog(@"Reply: %@", theReply);
    //NSLog(@"%@",theReply);
    
    if ([theReply rangeOfString:@"Array1"].location == NSNotFound) {
        NSLog(@"ADD NON RIUSCITO");
    } else {
        NSLog(@"ADD LOGIN RIUSCITO");
        
    }
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    // Usually the number of items in your array (the one that holds your list)
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return 70.;
    }
    else if (indexPath.row == 1){
        return 70.;
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
    // Configure the cell... setting the text of our cell's label
    //lista = [[NSArray alloc] initWithObjects:@"Dove:",@"Prezzo Negozio:",@"Prezzo Elite:",@"Consiliato da:", @"Codice Sconto:",@"Descrizione" ,nil];
    //cell.textLabel.text = [lista objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        UILabel *prices = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 100, 30)];
        prices.font = [UIFont fontWithName:@"Helvetica" size:15];
        prices.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        prices.backgroundColor = [UIColor clearColor];
        prices.text = @"Prezzo:";
        prices.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:prices];
        
        UILabel *pricesVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 50, 30)];
        pricesVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        pricesVal.textColor = [UIColor blackColor];
        pricesVal.backgroundColor = [UIColor clearColor];
        pricesVal.text = [prod.prezzo stringByAppendingString:@"  €"];
        pricesVal.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:pricesVal];
        
        UILabel *newpricesVal = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, 50, 30)];
        newpricesVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        newpricesVal.textColor = [UIColor blackColor];
        newpricesVal.backgroundColor = [UIColor clearColor];
        newpricesVal.text = [numberString stringByAppendingString:@"  €"];
        newpricesVal.textAlignment = NSTextAlignmentRight;
        [cell.contentView addSubview:newpricesVal];
        
        UIImageView *sbarra = [[UIImageView alloc] initWithFrame:CGRectMake(125, 15, 51, 15)];
        sbarra.image = [UIImage imageNamed:@"linea"];
        [cell.contentView addSubview:sbarra];
        
        UILabel *wheres = [[UILabel alloc]initWithFrame:CGRectMake(10, 35, 100, 30)];
        wheres.font = [UIFont fontWithName:@"Helvetica" size:15];
        wheres.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        wheres.backgroundColor = [UIColor clearColor];
        wheres.text = @"Dove:";
        wheres.textAlignment = NSTextAlignmentLeft;
        [cell.contentView addSubview:wheres];
        
        UILabel *wheresVal = [[UILabel alloc]initWithFrame:CGRectMake(120, 35, 200, 30)];
        wheresVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        wheresVal.textColor = [UIColor blackColor];
        wheresVal.backgroundColor = [UIColor clearColor];
        wheresVal.text = prod.where;
        [cell.contentView addSubview:wheresVal];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else if (indexPath.row == 1){
        
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
        codicescontoVal.font = [UIFont fontWithName:@"Helvetica" size:15];
        codicescontoVal.textColor = [UIColor blackColor];
        codicescontoVal.backgroundColor = [UIColor clearColor];
        codicescontoVal.text = prod.codice;
        [cell.contentView addSubview:codicescontoVal];
        
    }
    else if (indexPath.row == 2){
        cell.textLabel.text = @"Descrizione";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
        cell.textLabel.textColor = [UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2){
        
        DetailViewController *detail = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        UINavigationController *navDet = [[UINavigationController alloc] initWithRootViewController:detail];
        detail.detail = prod.desc;
        [self presentViewController:navDet animated:YES completion:nil];

        
    }
}

- (void)viewDidUnload {
    [self setName:nil];
    [self setWhere:nil];
    [self setPrezzo:nil];
    [self setPrezzo:nil];
    [self setFrom:nil];
    [self setDescrizione:nil];
    [self setCodice:nil];
    [self setImageProd:nil];
    [self setTabellaView:nil];
    [super viewDidUnload];
}
@end
