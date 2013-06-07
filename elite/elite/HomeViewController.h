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
#import <CoreLocation/CoreLocation.h>
#import "ODRefreshControl.h"

@interface HomeViewController : UITableViewController<CLLocationManagerDelegate>{
    ProdCell *itemCell;
    NSMutableArray *filteredListContent;
}
@property (retain, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, strong) FBSession * session;
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (nonatomic, retain) NSMutableArray *filteredListContent;
@property (nonatomic, retain) NSString *urlProdotti;
@property (weak, nonatomic) IBOutlet UIImageView *redLine;

@end
