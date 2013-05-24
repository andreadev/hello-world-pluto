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

@interface ProdottoViewController ()

@end

@implementation ProdottoViewController
@synthesize prod,name,where,prezzo,oldprezzo,from,descrizione,codice,imageProd,Scrollview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Scrollview setScrollEnabled:YES];//Abilitiamo lo scroll
    
    [Scrollview setContentSize:(CGSizeMake(320,600))];/*queste sono<span id="more-1890"></span> le dimesione 320 larghezza e 900 la lunghezza*/
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    self.name.text = prod.name;
    self.where.text = prod.where;
    self.prezzo.text = prod.prezzo;
    self.oldprezzo.text = prod.oldprezzo;
    self.from.text = @"Andrea Barbieri";
    self.descrizione.text = prod.desc;
    //self.title = prod.name;
    self.imageProd.layer.cornerRadius = 9.0 ;
    self.imageProd.layer.masksToBounds = YES ;
    self.imageProd.layer.borderColor = [UIColor whiteColor].CGColor ;
    self.imageProd.layer.borderWidth = 3.0 ;
    //imageProd.image = image;
    NSArray * array = [prod.url componentsSeparatedByString:@"/"];
    //int i = [array count];
    //i--;
    NSString *image_url= [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/product_images/thumb/%@",[array objectAtIndex:[array count]-1] ];
    
    [imageProd setImageFromUrl:[[NSURL alloc] initWithString:image_url] defaultImage:[UIImage imageNamed:@"53-house"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [super viewDidUnload];
}
@end
