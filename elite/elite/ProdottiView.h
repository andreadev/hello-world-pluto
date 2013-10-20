//
//  ProdottiView.h
//  elite
//
//  Created by Andrea Barbieri on 02/09/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdCell.h"
#import <CoreLocation/CoreLocation.h>
#import "ODRefreshControl.h"
#import "GAITrackedViewController.h"

@interface ProdottiView : UITableViewController{
    ProdCell *item;
}
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (nonatomic, retain) NSString *urlProdotti;
@property (weak, nonatomic) IBOutlet UIImageView *redLine;
@property (nonatomic, strong) NSMutableArray *ProdottiArray;

@end
