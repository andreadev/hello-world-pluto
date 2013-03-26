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
}
@end

@implementation NewProductViewController
@synthesize imageProd,nameProd,priceProd,categoryProd,shopProd,descProd,name,postParams,imageConnection,imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Nuovo Prodotto"
                                   image:[UIImage imageNamed:@"67-tshirt.png"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self populateUserDetails];
    // Do any additional setup after loading the view from its nib.
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
    
    NSData *imageD = UIImageJPEGRepresentation([UIImage imageNamed:@"test.png"],0.2);     //change Image to NSData
    NSString *ima = [[NSString alloc] initWithFormat:@"%@.jpg",nameProd.text ];
    
    NSString *desc = [[NSString alloc] initWithFormat:@"%@ ha appena consigliato: %@ su Elite.",name.text,nameProd.text ];
    
    self.postParams =
    [[NSMutableDictionary alloc] initWithObjectsAndKeys:
     @"http://eliteitalia.altervista.org", @"link",
     @"http://eliteitalia.altervista.org/webservice/product_images/mele.jpg", @"picture",
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
                               imageD,@"image",
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
    [self publishStory];
    
    NSURLResponse *response;
    NSData *POSTReply = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString *theReply = [[NSString alloc] initWithBytes:[POSTReply bytes] length:[POSTReply length] encoding: NSASCIIStringEncoding];
    NSLog(@"Reply: %@", theReply);
    
    
    
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


@end
