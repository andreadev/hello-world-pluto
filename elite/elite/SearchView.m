//
//  SearchView.m
//  elite
//
//  Created by Andrea Barbieri on 14/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "SearchView.h"
#import "ProdottiView.h"
#import "AppDelegate.h"
#import "CategoryView.h"
#import "GAI.h"

@interface SearchView (){
    UIPickerView *category;
    UIToolbar *toolBar;
    NSMutableArray *categorie;
    int category_id;
    CategoryView *categorieView;
    UINavigationController *navCate;
    
}

@end

@implementation SearchView
@synthesize searchText,segment,categoryView,rootController,categorianome,categoriaid,lat,lon;

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
    // Do any additional setup after loading the view from its nib.
    
    
    
    //[searchBotton setBackgroundImage:[UIImage imageNamed:@"ricerca"] forState:UIControlStateNormal];
    //[searchBotton setBackgroundImage:[UIImage imageNamed:@"ricercapa"] forState:UIControlStateHighlighted];
    [searchText becomeFirstResponder];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cerca" style:UIBarButtonItemStylePlain target:self action:@selector(cerca:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:btn,nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
}

- (void)viewDidUnload {
    [self setSearchText:nil];
    [self setSegment:nil];
    [self setCategoryView:nil];
    [super viewDidUnload];
}
- (IBAction)search:(id)sender {
    NSLog(@"%@",searchText.text);
    NSLog(@"%d",segment.selectedSegmentIndex);
    
}
- (IBAction)valueChange:(id)sender {
    
}

- (IBAction)cerca:(id)sender{
    NSString *valUser = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserID"];
    NSString *searchString;
    if (segment.selectedSegmentIndex == 0) {
       searchString = [[NSString alloc] initWithFormat:@"%@Prodotti/find_products.php?words=%@&?category=%@&user=%@", WEBSERVICEURL ,searchText.text,categoriaid,valUser ];
    }
    else{
        
    searchString = [[NSString alloc] initWithFormat:@"%@Prodotti/find_products_distance.php?words=%@&?category=%@&lat=%@&lon=%@&user=%@", WEBSERVICEURL ,searchText.text,categoriaid,lat,lon,valUser ];
    }
    NSLog(@"%@", searchString);
    ProdottiView *result = [[ProdottiView alloc] initWithNibName:@"ProdottiView" bundle:nil];
    result.urlProdotti = searchString;
    
    [self.navigationController pushViewController:result animated:YES];
    
    
}

- (IBAction)done:(id)sender {
    NSLog(@"done");
    [toolBar setHidden:YES];
    [category setHidden:YES];
}

- (IBAction)seeCategory:(id)sender {
    NSLog(@"category");
    categorieView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    navCate = [[UINavigationController alloc] initWithRootViewController:categorieView];
    categorianome = @"Seleziona Categoria";
    categorieView.search = self;
    [self presentViewController:navCate animated:YES completion:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // returns the same tracker you created in your app delegate
    // defaultTracker originally declared in AppDelegate.m
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    // manual screen tracking
    [tracker sendView:@"Home Screen"];
}
@end
