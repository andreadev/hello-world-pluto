//
//  DetailViewController.m
//  elite
//
//  Created by Andrea Barbieri on 03/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize detailText,detail;

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
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Fine" style:UIBarButtonItemStylePlain target:self action:@selector(pressedFinishButton)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated{
    detailText.text = detail;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) pressedFinishButton{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload {
    [self setDetailText:nil];
    [super viewDidUnload];
}
@end
