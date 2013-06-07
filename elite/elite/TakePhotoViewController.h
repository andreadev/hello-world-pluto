//
//  TakePhotoViewController.h
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadDetailViewController.h"


@interface TakePhotoViewController : UIViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong,nonatomic) UIImage *imageProd;

- (IBAction)takePicture:(id)sender;
@end
