//
//  WishlistView.h
//  elite
//
//  Created by Andrea Barbieri on 13/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdCell.h"
#import "ODRefreshControl.h"

@interface WishlistView : UITableViewController{
    ProdCell *itemCell;
    NSMutableArray *filteredListContent;
}
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, retain) NSString *urlProdotti;
@end
