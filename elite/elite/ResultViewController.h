//
//  ResultViewController.h
//  elite
//
//  Created by Andrea Barbieri on 07/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdCell.h"
#import "ODRefreshControl.h"
#import "ProductsView.h"
#import "Prodotto.h"
#import "AsyncImageView.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchView.h"

@interface ResultViewController : UITableViewController{
    ProdCell *itemCell;
    NSMutableArray *filteredListContent;
}

@property (strong, nonatomic) NSString *urlProdotti;
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (weak, nonatomic) IBOutlet UIImageView *redLine;

@end
