//
//  TutorialViewController.m
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "TutorialViewController.h"
#import "NewProductViewController.h"

@interface TutorialViewController ()
@end


@implementation TutorialViewController
@synthesize tabBarController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Prima";
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Next"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(nextButtonTapped)];
    
    self.navigationItem.rightBarButtonItem=nextButton;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Skip"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(skipButtonTapped)];
    
    self.navigationItem.leftBarButtonItem=backButton;
    
    // Do any additional setup after loading the view from its nib.
}

- (void) nextButtonTapped{
    NSLog(@"Cambia immagine");
}
- (void) skipButtonTapped{
    NSLog(@"Chiudi");
    [self.view removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
