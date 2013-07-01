//
//  LocalizeViewController.h
//  elite
//
//  Created by Andrea Barbieri on 07/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NewProductViewController.h"
#import "Shop.h"
#import "LoadDetailViewController.h"

@class LoadDetailViewController;

@interface LocalizeViewController : UITableViewController{
}
@property (strong, nonatomic) NSArray *shops;
@property (strong, nonatomic) NSString *latitudine;
@property (strong, nonatomic) NSString *longitudine;
@property (strong, nonatomic) Shop *shopSelected;

@property (strong, nonatomic) LoadDetailViewController *loadDetail;


@end
