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
#import "LocalizeViewController.h"
#import "GAITrackedViewController.h"
#import "ConsigliaPredView.h"
#import "CategoryView.h"


@interface LoadDetailViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, TTAlertViewDelegate>{
    CLLocationManager *locationManager;
}

@property (strong,nonatomic) UIImage *imageProd;
@property (strong,nonatomic) NSString *negozio;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UITableView *tabellaView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProd;

@property (strong,nonatomic) UITextField *name;
@property (strong,nonatomic) UITextField *price;
@property (strong,nonatomic) UITextField *where;
@property (strong,nonatomic) UITextField *category;
@property (strong,nonatomic) UITextField *desc;
@property (weak, nonatomic) IBOutlet UIButton *consiglia;
@property (weak, nonatomic) IBOutlet UIButton *consigliaTutti;

@property (strong, nonatomic) NSString *categoriaid;
@property (strong, nonatomic) NSString *categorianome;
@property (strong, nonatomic) NSString *negozioid;
@property (strong, nonatomic) NSString *negozionome;



- (IBAction)seeConsiglia:(id)sender;
- (IBAction)seeConsigliaPreferiti:(id)sender;


@end
