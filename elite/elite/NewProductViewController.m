//
//  NewProductViewController.m
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "NewProductViewController.h"


@interface NewProductViewController (){
    NSString *filenames;
}
@end

@implementation NewProductViewController
@synthesize imageProd,nameProd,priceProd,categoryProd,shopProd,descProd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Nuovo Prodotto"
                                   image:[UIImage imageNamed:@"prodotto.png"]
                                   tag:0];
        self.tabBarItem=tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [super viewDidUnload];
}
- (IBAction)photo:(id)sender {
}

- (IBAction)consiglia:(id)sender {
    
    //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"test.png"],0.2);     //change Image to NSData
    
    NSDictionary *prodDict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"aname", @"name",
                               @"11", @"store_id",
                               @"12", @"price",
                               @"13", @"category_id",
                               @"212131", @"insertion_code",
                               @"url", @"imageurl",
                               nil];
    
    
    //NSString *jsonString = [loginDict JSONRepresentation];
    
    /*NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //NSString *post = [NSString stringWithFormat:@"json=%@", jsonString];
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
    //convert object to data
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:prodDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    
    [request setURL:[NSURL URLWithString:@"http://eliteitalia.altervista.org/webservice/Prodotti/create_product.php"]];
    
    
    [request setHTTPMethod:@"POST"];
    
    
    //[request setHTTPMethod:@"POST"];
    [request setHTTPBody:jsonData];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //[[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSError *aerror;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&aerror];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(returnString);
    NSLog(@"finish");*/
    
    //NSString *post = [NSString stringWithFormat:@"example"];
    NSError *error;
    
    //NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
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
    
    
}
@end
