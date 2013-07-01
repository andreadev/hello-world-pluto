//
//  TakePhotoViewController.h
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadDetailViewController.h"
#import "GAITrackedViewController.h"

@interface TakePhotoViewController : GAITrackedViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (strong,nonatomic) UIImage *imageProd;

- (IBAction)takePicture:(id)sender;
@end
