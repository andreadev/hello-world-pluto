//
//  DetailViewController.h
//  elite
//
//  Created by Andrea Barbieri on 03/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (strong,nonatomic) NSString *detail;


@end
