//
//  NewProductViewController.h
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>
#import "User.h"
#import "JGProgressView.h"


@interface NewProductViewController : UIViewController<UINavigationControllerDelegate , UIImagePickerControllerDelegate , UIActionSheetDelegate , UITextFieldDelegate, CLLocationManagerDelegate, UIPickerViewDelegate,UIPickerViewDataSource >
{
    CLLocationManager *locationManager;
    IBOutlet UIScrollView *scrollView;

}
@property (strong, nonatomic) User *CurrentUser;
@property (strong, nonatomic) NSString *negozio;
@property (nonatomic, strong) FBSession * session;


@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageProd;
@property (weak, nonatomic) IBOutlet UITextField *nameProd;
@property (weak, nonatomic) IBOutlet UITextField *priceProd;
@property (weak, nonatomic) IBOutlet UITextField *descProd;

@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

//BUTTON
@property (weak, nonatomic) IBOutlet UIButton *moreCate;
@property (weak, nonatomic) IBOutlet UIButton *moreShop;
@property (weak, nonatomic) IBOutlet UIButton *takePhoto;
@property (weak, nonatomic) IBOutlet UIButton *consiglia;
@property (weak, nonatomic) IBOutlet UIButton *consigliaTutti;



- (IBAction)consigliaPreferiti:(id)sender;
- (IBAction)seeCategory:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)seeNegozi:(id)sender;
- (IBAction)viewCategory:(id)sender;
- (IBAction)photo:(id)sender;
- (IBAction)done:(id)sender;
- (IBAction)consiglia:(id)sender;
- (IBAction)descrizione:(id)sender;
- (IBAction)finisciDescrizione:(id)sender;
- (void) setNegozio:(NSString *)negozio;

@end
