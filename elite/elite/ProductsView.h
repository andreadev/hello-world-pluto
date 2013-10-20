//
//  ProductsView.h
//  elite
//
//  Created by Andrea Barbieri on 30/08/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Prodotto.h"
#import "RemoteImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "TTAlertView.h"
#import "CXPhotoBrowser/CXPhotoBrowser.h"
#import "DetailViewController.h"

@interface ProductsView : UITableViewController<CXPhotoBrowserDataSource,CXPhotoBrowserDelegate>

@property (retain, nonatomic) UIImageView *imageProd;
@property (retain, nonatomic) UIView *headerView;
@property (retain, nonatomic) UIView *footerView;
@property (strong, nonatomic) Prodotto *prod;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *where;
@property (weak, nonatomic) IBOutlet UILabel *prezzo;
@property (weak, nonatomic) IBOutlet UILabel *oldprezzo;
@property (weak, nonatomic) IBOutlet UILabel *from;
@property (weak, nonatomic) IBOutlet UITextView *descrizione;
@property (weak, nonatomic) IBOutlet UILabel *codice;
@property (strong, nonatomic) NSString *isWishlist;
@property (strong,nonatomic) NSString *isProfilo;

@end
