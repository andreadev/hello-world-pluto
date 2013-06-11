//
//  LocationViewController.h
//  elite
//
//  Created by Andrea Barbieri on 22/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadDetailViewController.h"

@interface LocationViewController : UITableViewController

@property (strong, nonatomic) NSArray *shops;
@property (strong, nonatomic) NSString *latitudine;
@property (strong, nonatomic) NSString *longitudine;

@end
