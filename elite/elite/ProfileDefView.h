//
//  ProfileDefView.h
//  elite
//
//  Created by Andrea Barbieri on 23/08/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProdCell.h"

@interface ProfileDefView : UITableViewController{
    ProdCell *itemCell;
}
@property (nonatomic, strong) IBOutlet ProdCell *itemCell;
@property (nonatomic, strong) NSArray *prodotti;
@property (nonatomic, retain) NSString *urlProdotti;

- (void)consigliatomi;
- (void) pushProduct;

@end
