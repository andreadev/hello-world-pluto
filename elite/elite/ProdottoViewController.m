//
//  ProdottoViewController.m
//  elite
//
//  Created by Andrea Barbieri on 25/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdottoViewController.h"
#import "AsyncImageView.h"

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
    
    //get image view
	AsyncImageView *imageView;
	
    //cancel loading previous image for cell
    [[AsyncImageLoader sharedLoader] cancelLoadingURL:imageView.imageURL];
    
    imageView.imageURL = [[NSURL alloc] initWithString:prod.url];
    
    self.imageProd.image = imageView.image ;
    
    
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
