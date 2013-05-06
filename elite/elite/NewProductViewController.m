//
//  NewProductViewController.m
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "NewProductViewController.h"
#import "LoginViewController.h"


@interface NewProductViewController (){
    NSString *filenames;
    NSArray *negozi;
    NSString *lat,*lon;
    
}
@end

@implementation NewProductViewController
@synthesize imageProd,nameProd,priceProd,categoryProd,shopProd,descProd,name,postParams,imageConnection,imageData,locationManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Nuovo Prodotto"
                                   image:[UIImage imageNamed:@"67-tshirt"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLocationManager:[[CLLocationManager alloc] init]];
    [locationManager setDelegate:self];
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager startUpdatingLocation];
    
    //[self populateUserDetails];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    [self populateUserDetails];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setImageProd:nil];
    [self setNameProd:nil];
    [self setPriceProd:nil];
    [self setCategoryProd:nil];
    [self setShopProd:nil];
    [self setDescProd:nil];
    [self setName:nil];
    [super viewDidUnload];
}
- (IBAction)logout:(id)sender {
    
    [FBSession.activeSession closeAndClearTokenInformation];
    LoginViewController *login= [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    
    [self presentModalViewController:login animated:NO];
}

- (IBAction)seeNegozi:(id)sender {
    NSString * url = [[NSString alloc] initWithFormat:@"http://cosapensidime.ilbello.com/webservice/geoloc/get_stores_get.php?lat=%@&lng=%@&dist=50", lat, lon];
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES]; });
    
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
                 NSLog(@"%@", user.name);
                 NSLog(@"%@", user.id);
             }
         }];
    }
}


- (IBAction)consiglia:(id)sender {
    
    //UPLOAD IMMAGINE
    NSLog(@"Immagine");
    
    
    
    NSData *imageDatas = UIImageJPEGRepresentation(imageProd.image,0.1);     //change Image to NSData
    NSString *ima = [nameProd.text stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    if (imageDatas != nil)
    {
        filenames = [NSString stringWithFormat:ima];      //set name here
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
        NSLog(returnString);
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
    
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               nameProd.text, @"name",
                               shopProd.text, @"store_id",
                               priceProd.text, @"price",
                               categoryProd.text, @"category_id",
                               @"Dummy", @"insertion_code",
                               ima, @"imageurl",
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
    [self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    // Load the image
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
             alertText = [NSString stringWithFormat:
                          @"Posted action, id: %@",
                          [result objectForKey:@"id"]];
         }
         // Show the result in an alert
         [[[UIAlertView alloc] initWithTitle:@"Result"
                                     message:alertText
                                    delegate:self
                           cancelButtonTitle:@"OK!"
                           otherButtonTitles:nil]
          show];
     }];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"entrooooooooo");
    
    lat =[NSString stringWithFormat:@"%f", newLocation.coordinate.latitude];
    
    lon = [NSString stringWithFormat:@"%f", newLocation.coordinate.longitude];
    
}


@end
