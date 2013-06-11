//
//  SearchView.m
//  elite
//
//  Created by Andrea Barbieri on 14/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "SearchView.h"
#import "ResultViewController.h"
@interface SearchView (){
    UIPickerView *category;
    UIToolbar *toolBar;
    NSMutableArray *categorie;
    int category_id;
}

@end

@implementation SearchView
@synthesize searchBotton,searchText,segment,categoryText,categoryView,rootController;

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
    categorie = [[NSMutableArray alloc] initWithObjects:@"Tutte",@"Abbigliamento e Accessori",@"Arte",@"Audio",@"Bellezza e Salute",@"Casa, Arredamento e Bricolage",@"Collezionismo",@"CD e DVD",@"Giocattoli e Modellismo",@"Infanzia e Premaman",@"Informatica",@"Libri, Riviste e Fumetti",@"Orologi, Occhiali e Gioielli",@"Musica e Strumenti Musicali",@"Telefonia",@"Videogiochi e Console",@"Altro", nil];
    
    category = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 205, 320, 20)];
    category.showsSelectionIndicator = YES;
    category.delegate = self;
    [category setHidden:YES];
    toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 163, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    [toolBar setHidden:YES];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Fine" style:UIBarButtonItemStylePlain target:self action:@selector(cerca)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:btn,nil]];
    [self.view addSubview:toolBar];
    
    [self.view addSubview:category];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void) cerca{
    NSString *searchString = [[NSString alloc] initWithFormat:@"http://eliteitalia.altervista.org/webservice/Prodotti/get_products.php?words=%@&?category=%d&?or=%d", searchText.text,category_id,segment.selectedSegmentIndex ];
    
    ResultViewController *result = [[ResultViewController alloc] initWithNibName:@"ResultViewController" bundle:nil];
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
    [toolBar setHidden:NO];
    [category setHidden:NO];
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
    categoryText.text = [categorie objectAtIndex:row];
    category_id = row;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
