//
//  ProdCell.m
//  elite
//
//  Created by Andrea Barbieri on 24/03/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "ProdCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ProdCell
@synthesize prodImage,nameProd,Price,oldPrice,whereProd,redLine;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.layer.cornerRadius = 15.0;
        self.layer.masksToBounds = YES;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
