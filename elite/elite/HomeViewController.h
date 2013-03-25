//
//  HomeViewController.h
//  elite
//
//  Created by Andrea Barbieri on 22/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ProdCell.h"

@interface HomeViewController : UITableViewController{
    ProdCell *itemCell;
}
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, strong) FBSession * session;
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;

@end
