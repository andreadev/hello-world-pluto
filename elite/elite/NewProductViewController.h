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



@interface NewProductViewController : UIViewController<UINavigationControllerDelegate , UIImagePickerControllerDelegate , UIActionSheetDelegate , UITextFieldDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;

}
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *imageProd;
@property (weak, nonatomic) IBOutlet UITextField *nameProd;
@property (weak, nonatomic) IBOutlet UITextField *priceProd;
@property (weak, nonatomic) IBOutlet UITextField *categoryProd;
@property (weak, nonatomic) IBOutlet UITextField *shopProd;
@property (weak, nonatomic) IBOutlet UITextField *descProd;
@property (nonatomic, strong) FBSession * session;
@property (strong, nonatomic) NSMutableDictionary *postParams;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *imageConnection;

- (IBAction)logout:(id)sender;
- (IBAction)seeNegozi:(id)sender;


- (IBAction)photo:(id)sender;

- (IBAction)consiglia:(id)sender;
@end
