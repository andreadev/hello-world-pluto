//
//  LoadDetailViewController.h
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "TTAlertView.h"
#import "JGProgressView.h"
#import "LocationViewController.h"
#import "LocalizeViewController.h"


@interface LoadDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong,nonatomic) UIImage *imageProd;
@property (strong,nonatomic) NSString *negozio;

@property (weak, nonatomic) IBOutlet UITableView *tabellaView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProd;

@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UITextField *price;
@property (strong,nonatomic) UITextField *where;
@property (strong,nonatomic) UITextField *category;
@property (strong,nonatomic) UITextField *desc;
@property (weak, nonatomic) IBOutlet UIButton *consiglia;
@property (weak, nonatomic) IBOutlet UIButton *consigliaTutti;

- (IBAction)seeConsiglia:(id)sender;
- (IBAction)seeConsigliaTutti:(id)sender;


@end
