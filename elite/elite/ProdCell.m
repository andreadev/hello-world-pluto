//
//  ProdCell.m
//  elite
//
//  Created by Andrea Barbieri on 24/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdCell.h"

@implementation ProdCell
@synthesize prodImage,nameProd,Price,oldPrice,whereProd;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
