//
//  FriendCell.m
//  elite
//
//  Created by Andrea Barbieri on 07/05/13.
//  Copyright (c) 2013 Andrea. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell
@synthesize follow,imageName,labelNome;

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
