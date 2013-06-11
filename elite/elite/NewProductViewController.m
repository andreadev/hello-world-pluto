//
//  NewProductViewController.m
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "NewProductViewController.h"
#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "User.h"
#import "AppDelegate.h"
#import "LocationViewController.h"


@interface NewProductViewController (){
    NSString *filenames;
    NSArray *negozi;
    NSString *lat,*lon;
    UIPickerView *category;
    UIToolbar *toolBar;
    NSMutableArray *categorie;
    int category_id;
    JGProgressView *p;
    
}
@end

@implementation NewProductViewController
@synthesize imageProd,nameProd,priceProd,descProd,name,postParams,imageConnection,imageData,locationManager,session,moreCate,scrollView,moreShop,consiglia,consigliaTutti,takePhoto,negozio,CurrentUser;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Nuovo Prodotto"
                                   image:[UIImage imageNamed:@"13-plus"]
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
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consigliablue"] forState:UIControlStateNormal];
    [consiglia setBackgroundImage:[UIImage imageNamed:@"consigliabianco"] forState:UIControlStateHighlighted];
    
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaprefblue"] forState:UIControlStateNormal];
    [consigliaTutti setBackgroundImage:[UIImage imageNamed:@"consigliaprefbianco"] forState:UIControlStateHighlighted];
    [takePhoto setBackgroundColor:[UIColor clearColor]];
    imageProd.image = [UIImage imageNamed:@"camerabianca"];
    [takePhoto setBackgroundImage:[UIImage imageNamed:@"camerablu"] forState:UIControlStateHighlighted];
    [priceProd setBackground:[UIImage imageNamed:@"bianco80"]];
    [descProd setBackground:[UIImage imageNamed:@"bianco140"]];
    [nameProd setBackground:[UIImage imageNamed:@"bianco80"]];
    
    
    [scrollView setScrollEnabled:NO];//Abilitiamo lo scroll
    
    [scrollView setContentSize:(CGSizeMake(320,600))];
    categorie = [[NSMutableArray alloc] initWithObjects:@"Abbigliamento e Accessori",@"Arte",@"Audio",@"Bellezza e Salute",@"Casa, Arredamento e Bricolage",@"Collezionismo",@"CD e DVD",@"Giocattoli e Modellismo",@"Infanzia e Premaman",@"Informatica",@"Libri, Riviste e Fumetti",@"Orologi, Occhiali e Gioielli",@"Musica e Strumenti Musicali",@"Telefonia",@"Videogiochi e Console",@"Altro", nil];
    
    category = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 205, 320, 20)];
    category.showsSelectionIndicator = YES;
    category.delegate = self;
    [category setHidden:YES];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 163, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    [toolBar setHidden:YES];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:btn,nil]];
    [self.view addSubview:toolBar];
    
    [self.view addSubview:category];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    negozio = @"Negozio";
    
    //imageProd.layer.cornerRadius = 20;//half of the width
    //imageProd.layer.borderColor=[UIColor colorWithRed:6/255.0f green:105/255.0f blue:162/255.0f alpha:1.0f].CGColor;
    //imageProd.layer.borderWidth=3.0f;
    //self.title = @"Elite";
    
    //[self populateUserDetails];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)viewCategory:(id)sender {
    NSLog(@"category");
    [toolBar setHidden:NO];
    [category setHidden:NO];
}
- (void) viewWillAppear:(BOOL)animated{
    //[self populateUserDetails];
    //self.moreShop.titleLabel.text = negozio;
    NSLog(@"%@",negozio);
    
    [moreShop setTitle:negozio forState:UIControlStateNormal];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)descrizione:(id)sender{
    [scrollView setScrollEnabled:YES];
    [self.scrollView setContentOffset:CGPointMake(0.0, 70.0) animated:YES];
    //self.scrollView.contentOffset = CGPointMake(0.0, 90.0);

    
}

- (IBAction)finisciDescrizione:(id)sender {
    [scrollView setScrollEnabled:NO];
    [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    //self.scrollView.contentOffset = CGPointMake(0.0, 0.0);
}

- (void)viewDidUnload {
    [self setImageProd:nil];
    [self setNameProd:nil];
    [self setPriceProd:nil];
    [self setDescProd:nil];
    [self setName:nil];
    [self setMoreCate:nil];
    [self setScrollView:nil];
    [self setMoreShop:nil];
    [self setTakePhoto:nil];
    [self setConsiglia:nil];
    [self setConsigliaTutti:nil];
    [super viewDidUnload];
}
- (IBAction)consigliaPreferiti:(id)sender {
}

- (IBAction)seeCategory:(id)sender {
    NSLog(@"category");
    [toolBar setHidden:NO];
    [category setHidden:NO];
}

- (IBAction)logout:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    [[AppDelegate getApplicationDelegate] presentLoginController];
    
    
}

- (IBAction)done:(id)sender {
    NSLog(@"done");
    [toolBar setHidden:YES];
    [category setHidden:YES];
}

- (IBAction)seeNegozi:(id)sender {
    LocationViewController *location = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    UINavigationController *navLoc = [[UINavigationController alloc] initWithRootViewController:location];
    location.latitudine = lat;
    location.longitudine = lon;
    //location. = self;
    
    [self presentModalViewController:navLoc animated:YES];
    /*
    NSString * url = [[NSString alloc] initWithFormat:@"http://cosapensidime.ilbello.com/webservice/geoloc/get_stores_get.php?lat=%@&lng=%@&dist=50", lat, lon];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });*/
    
}


- (void)fetchedData:(NSData *)responseData {
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     options:kNilOptions error:nil];
    negozi = json;
    //TmpTitle = [[NSMutableArray alloc] initWithCapacity:[json count]];
    [self loadNegozi];
    
    
    
}

- (void) loadNegozi{
    for (int i =0 ; i< [negozi count]; i++) {
        NSString *nome = [[negozi objectAtIndex:i] objectForKey:@"Name"];
        NSLog(@"NEGOZIO");
        NSLog(@"%@",nome);
    }

}

- (IBAction)photo:(id)sender {
            
            // si - Attiva fotocamera in modalità editing
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [picker setDelegate: self ];
            [picker setAllowsEditing: NO ];
            [picker setSourceType: UIImagePickerControllerSourceTypeCamera ];
            [self presentModalViewController: picker animated: YES ];
            //[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    // si - salviamo la foto appena scattata/scelta in un array
    imageProd.layer.cornerRadius = 9.0 ;
    imageProd.layer.masksToBounds = YES ;
    //imageProd.layer.borderColor = [UIColor blackColor].CGColor ;
    imageProd.layer.borderWidth = 3.0 ;
    imageProd.image = image;
    
    
    //
    
    [picker dismissModalViewControllerAnimated:YES];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	[picker dismissModalViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection,
           NSDictionary<FBGraphUser> *user,
           NSError *error) {
             if (!error) {
                 name.text = user.name;
                 CurrentUser.name= user.name;
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
             }
         }];
    }
}


- (IBAction)consiglia:(id)sender {
    
    //UPLOAD IMMAGINE
    
    p = [[JGProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [p setUseSharedImages:YES];
    p.frame = CGRectMake(20, 5, 280, p.frame.size.height);
    p.center = CGPointMake(CGRectGetMidX(self.view.bounds), p.center.y);
    
    [self.view addSubview:p];
    p.animationSpeed = 1.0;
    [p setIndeterminate:YES];
    
    
    NSLog(@"Immagine");
    
    
    
    NSData *imageDatas = UIImageJPEGRepresentation(imageProd.image,0.1);     //change Image to NSData
    NSString *ima = [nameProd.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if (imageDatas != nil)
    {
              //set name here
        filenames = [NSString stringWithFormat:ima];
        NSLog(@"%@", filenames);
        NSString *urlString = @"http://eliteitalia.altervista.org/webservice/Prodotti/upload_image.php";
        
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
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        //NSLog(returnString);
        NSLog(@"finish");
    }
    
         //change Image to NSData
    

    ima = [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/product_images/%@.jpg",ima ];
    
    NSString *desc = [[NSString alloc] initWithFormat:@"%@ ha appena consigliato: %@ su Elite.",name.text,nameProd.text ];
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"www.eliteadvice.tk", @"link",
     ima, @"picture",
     desc, @"name",
     @"Il social Network che ti fa risparmiare.", @"caption",
     @"Scopri Elite Advice e risparmia su ogni acquisto.", @"description",
     nil];
    
    CurrentUser.user = [[NSUserDefaults standardUserDefaults] stringForKey:@"User"];
    NSLog(@"USER %@",CurrentUser.user);
    NSString *testoSalvato = [[NSUserDefaults standardUserDefaults] objectForKey:@"User"];
	if (testoSalvato == nil) {
		testoSalvato = @"NO NAME";
	} 
    
        NSString *cat = [[NSString alloc] initWithFormat:@"%d",category_id ];
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               nameProd.text, @"name",
                               moreShop.titleLabel.text, @"store_id",
                               priceProd.text, @"price",
                               cat, @"category_id",
                               @"Dummy", @"insertion_code",
                               ima, @"imageurl",
                              testoSalvato,@"username",
                              descProd.text,@"desc",
                               nil];
    
    
    NSError *error;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"%@",postData);
    
    
    NSString *postLength = [NSString stringWithFormat:@"12321443"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://eliteitalia.altervista.org/webservice/Prodotti/create_product.php"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    
    
    [self publishStory];
    
}
-(void)connection:(NSURLConnection*)connection
didReceiveData:(NSData*)data{
    NSLog(@"Carico");
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
    NSLog(@"finisco");
    self.imageProd.image = [UIImage imageWithData:
                                [NSData dataWithData:self.imageData]];
    self.imageConnection = nil;
    self.imageData = nil;
    
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error{
    self.imageConnection = nil;
    self.imageData = nil;
}

- (void)publishStory
{
    [FBRequestConnection
     startWithGraphPath:@"me/feed"
     parameters:self.postParams
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
         [p removeFromSuperview];
     }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"Location");
    
    lat =[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    
    lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [categorie count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    id str=[categorie objectAtIndex:row];
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selectedRowInPicker >> %d",row);
    NSString *t = [categorie objectAtIndex:row];
    [moreCate setTitle:t forState:UIControlStateNormal];
    
    category_id = row;
}
@end
