//
//  ProfileViewController.h
//  elite
//
//  Created by Andrea Barbieri on 11/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdCell.h"
#import "ODRefreshControl.h"

@interface ProfileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    ProdCell *itemCell;
    NSMutableArray *filteredListContent;
}

@property (weak, nonatomic) IBOutlet UITableView *tabellaView;
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, retain) NSString *urlProdotti;
@end
