//
//  SearchView.m
//  elite
//
//  Created by Andrea Barbieri on 14/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "SearchView.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "CategoryView.h"

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
@synthesize searchBotton,searchText,segment,categoryText,categoryView,rootController,categorianome,categoriaid;

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
    
    categorieView = [[CategoryView alloc] initWithNibName:@"CategoryView" bundle:nil];
    navCate = [[UINavigationController alloc] initWithRootViewController:categorieView];
    categorianome = @"Seleziona Categoria";
    //UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cerca" style:UIBarButtonItemStylePlain target:self action:@selector(cerca)];
    //self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:btn,nil]];
    //[self.view addSubview:toolBar];
    
    //[self.view addSubview:category];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated{
    categoryText.text = categorianome;
}

- (void)viewDidUnload {
    [self setSearchText:nil];
    [self setSegment:nil];
    [self setCategoryText:nil];
    [self setCategoryView:nil];
    [self setSearchBotton:nil];
    [super viewDidUnload];
}
- (IBAction)search:(id)sender {
    NSLog(@"%@",searchText.text);
    NSLog(@"%d",segment.selectedSegmentIndex);
    
    //NSString *searchString = [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/Prodotti/get_products.php?words=%@&?category=%d&?or=%d", searchText.text,category_id,segment.selectedSegmentIndex ];
    
    //result.urlProdotti = searchString;
    
}
- (IBAction)valueChange:(id)sender {
    
}

- (IBAction)cerca:(id)sender{
    NSString *searchString = [[NSString alloc] initWithFormat:@"%@Prodotti/find_products.php?words=%@&?category=%@&?or=%d", WEBSERVICEURL ,searchText.text,categoriaid,segment.selectedSegmentIndex ];
    
    HomeViewController *result = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
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
    categorieView.search = self;
    [self presentViewController:navCate animated:YES completion:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
