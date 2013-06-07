//
//  LoadDetailViewController.h
//  elite
//
//  Created by Andrea Barbieri on 05/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LoadDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UIImage *imageProd;

@property (weak, nonatomic) IBOutlet UITableView *tabellaView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProd;
@end
