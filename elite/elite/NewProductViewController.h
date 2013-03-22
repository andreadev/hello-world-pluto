//
//  NewProductViewController.h
//  elite
//
//  Created by Andrea Barbieri on 17/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewProductViewController : UIViewController<NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageProd;
@property (weak, nonatomic) IBOutlet UITextField *nameProd;
@property (weak, nonatomic) IBOutlet UITextField *priceProd;
@property (weak, nonatomic) IBOutlet UITextField *categoryProd;
@property (weak, nonatomic) IBOutlet UITextField *shopProd;
@property (weak, nonatomic) IBOutlet UITextField *descProd;
- (IBAction)photo:(id)sender;

- (IBAction)consiglia:(id)sender;
@end
