//
//  ProdCell.h
//  elite
//
//  Created by Andrea Barbieri on 24/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProdCell : UITableViewCell{
    UILabel *oldPrice;
    UILabel *Price;
    UILabel *whereProd;
    UILabel *nameProd;
    UIImageView *prodImage;
}


@property (nonatomic, strong) IBOutlet UILabel *oldPrice;
@property (nonatomic, strong) IBOutlet UILabel *Price;

@property (nonatomic, strong) IBOutlet UILabel *whereProd;
@property (nonatomic, strong) IBOutlet UIImageView *prodImage;
@property (nonatomic, strong) IBOutlet UILabel *nameProd;
@end
