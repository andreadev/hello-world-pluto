//
//  CategoryView.h
//  elite
//
//  Created by Andrea Barbieri on 29/06/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchView.h"
#import "LoadDetailViewController.h"

@class LoadDetailViewController;
@class SearchView;

@interface CategoryView : UITableViewController{
}

@property (strong, nonatomic) LoadDetailViewController *loadDetail;
@property (strong, nonatomic) SearchView *search;

@end
