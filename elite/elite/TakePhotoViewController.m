//
//  TakePhotoViewController.m
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "TakePhotoViewController.h"

@interface TakePhotoViewController (){
    LoadDetailViewController *detail;
}

@end

@implementation TakePhotoViewController
@synthesize imageProd;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *tabBarItem =[[UITabBarItem alloc]
                                   initWithTitle:@"Nuovo Prodotto"
                                   image:[UIImage imageNamed:@"13-plus"]
                                   tag:0];
        //[UIColor colorWithRed:220.0/255.0 green:104.0/255.0 blue:1.0/255.0 alpha:1.0], UITextAttributeTextColor,
        [tabBarItem setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          
          nil, UITextAttributeTextShadowColor,
          nil, UITextAttributeTextShadowOffset,
          [UIFont fontWithName:@"Helvetica" size:8.5], UITextAttributeFont,
          nil] forState:UIControlStateNormal];
        
        self.tabBarItem=tabBarItem;
        UIImageView *navImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoelitenav"]];
        self.navigationItem.titleView = navImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //[self attivaPhoto];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.trackedViewName = @"TakePhoto Screen";
}

- (void) viewWillAppear:(BOOL)animated{
    [self attivaPhoto];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) attivaPhoto{
    // si - Attiva fotocamera in modalità editing
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker setDelegate: self ];
    [picker setAllowsEditing: NO ];
    [picker setSourceType: UIImagePickerControllerSourceTypeCamera ];
    [self presentViewController:picker animated:YES completion:nil];
    //[picker release];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    
    
    detail = [[LoadDetailViewController alloc] initWithNibName:@"LoadDetailViewController" bundle:nil];
    detail.imageProd = image;
    [self.navigationController pushViewController:detail animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
	[picker dismissViewControllerAnimated:YES completion:nil];
    
}



- (IBAction)takePicture:(id)sender {
    [self attivaPhoto];
}
@end
